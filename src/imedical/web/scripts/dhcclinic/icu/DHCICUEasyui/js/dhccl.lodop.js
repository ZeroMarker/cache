function CLLodop(opts){
    this.opts=opts;
    this.lodop=opts.lodop;
    if(!this.lodop){
        this.lodop=getLodop();
    }
}

CLLodop.prototype={
    constructor:CLLodop,
    drawDataItem:function(startPosX,startPosY,title,value,unit,lineWidth,fontSize){
        this.lodop.ADD_PRINT_TEXT(startPosY,startPosX,"100%","100%",title);
    }
}