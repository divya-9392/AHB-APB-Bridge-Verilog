module apb_controller(
    input hclk,
    input hresetn,

    input valid,
    input hwrite,
    input hwritereg,

    input [31:0] haddr,
    input [31:0] hwdata,

    input [31:0] haddr1,
    input [31:0] haddr2,

    input [31:0] hwdata1,
    input [31:0] hwdata2,

    input [2:0] tempselx,

    output reg pwrite,
    output reg penable,
    output reg [2:0] psel,
    output reg hreadyout,

    output reg [31:0] pwdata,
    output reg [31:0] paddr
);

parameter st_idle     = 3'b000,
          st_wait     = 3'b001,
          st_write    = 3'b010,
          st_writep   = 3'b011,
          st_wenablep = 3'b100,
          st_wenable  = 3'b101,
          st_read     = 3'b110,
          st_renable  = 3'b111;

reg [2:0] state,next_state;

reg [31:0] paddr_temp,pwdata_temp;
reg penable_temp,pwrite_temp,hreadyout_temp;
reg [2:0] psel_temp;


always @(posedge hclk)
begin
    if(!hresetn)
        state <= st_idle;
    else
        state <= next_state;
end

always @(*)
begin
    case(state)

    st_idle:
    begin
        if(valid && hwrite)
            next_state = st_wait;
        else if(valid && !hwrite)
            next_state = st_read;
        else
            next_state = st_idle;
    end

    st_wait:
    begin
        if(valid)
            next_state = st_writep;
        else
            next_state = st_write;
    end

    st_write:
        next_state = st_wenable;

    st_writep:
        next_state = st_wenablep;

    st_read:
        next_state = st_renable;

    st_wenable:
    begin
        if(valid && !hwrite)
            next_state = st_read;
        else if(!valid)
            next_state = st_idle;
        else
            next_state = st_wenable;
    end

    st_wenablep:
    begin
        if(valid && hwritereg)
            next_state = st_writep;
        else if(!hwritereg)
            next_state = st_read;
        else if(!valid)
            next_state = st_write;
        else
            next_state = st_wenablep;
    end

    st_renable:
    begin
        if(valid && !hwrite)
            next_state = st_read;
        else if(valid && hwrite)
            next_state = st_wait;
        else
            next_state = st_idle;
    end

    default:
        next_state = st_idle;

    endcase
end

always @(*)
begin

    paddr_temp       = 32'd0;
    pwdata_temp      = 32'd0;
    pwrite_temp      = 1'b0;
    psel_temp        = 3'b000;
    penable_temp     = 1'b0;
    hreadyout_temp   = 1'b1;

    case(state)

    st_idle:
    begin
        if(valid && !hwrite)
        begin
            paddr_temp       = haddr;
            pwrite_temp      = hwrite;
            psel_temp        = tempselx;
            penable_temp     = 0;
            hreadyout_temp   = 0;
        end
        else if(valid && hwrite)
        begin
            psel_temp        = 0;
            penable_temp     = 0;
            hreadyout_temp   = 1;
        end
    end

    st_wait:
    begin
        paddr_temp       = haddr1;
        pwdata_temp      = hwdata;
        pwrite_temp      = hwrite;
        psel_temp        = tempselx;
        penable_temp     = 0;
        hreadyout_temp   = 0;
    end

    st_write:
    begin
        penable_temp     = 1;
        hreadyout_temp   = 1;
    end

    st_writep:
    begin
        penable_temp     = 1;
        hreadyout_temp   = 1;
    end

    st_wenable:
    begin
        paddr_temp       = haddr1;
        pwdata_temp      = hwdata;
        pwrite_temp      = hwrite;
        psel_temp        = tempselx;
        penable_temp     = 0;
        hreadyout_temp   = 0;
    end

    st_wenablep:
    begin
        paddr_temp       = haddr1;
        pwdata_temp      = hwdata;
        pwrite_temp      = hwrite;
        psel_temp        = tempselx;
        penable_temp     = 0;
        hreadyout_temp   = 0;
    end

    st_read:
    begin
        penable_temp     = 1;
        hreadyout_temp   = 1;
    end

    st_renable:
    begin
        if(valid && !hwrite)
        begin
            paddr_temp       = haddr;
            pwrite_temp      = hwrite;
            psel_temp        = tempselx;
            penable_temp     = 0;
            hreadyout_temp   = 0;
        end
        else if(valid && hwrite)
        begin
            psel_temp        = 0;
            penable_temp     = 0;
            hreadyout_temp   = 1;
        end
    end

    endcase
end



always @(posedge hclk)
begin
    if(!hresetn)
    begin
        paddr      <= 0;
        pwdata     <= 0;
        pwrite     <= 0;
        psel       <= 0;
        penable    <= 0;
        hreadyout  <= 1;
    end
    else
    begin
        paddr      <= paddr_temp;
        pwdata     <= pwdata_temp;
        pwrite     <= pwrite_temp;
        psel       <= psel_temp;
        penable    <= penable_temp;
        hreadyout  <= hreadyout_temp;
    end
end

endmodule
