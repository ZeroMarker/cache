function unitConversion() {
    /**
     * ��ȡDPI
     * @returns {Array}
     */
    this.conversion_getDPI =function () {
        var arrDPI = new Array;
        if (window.screen.deviceXDPI) {
            arrDPI[0] = window.screen.deviceXDPI;
            arrDPI[1] = window.screen.deviceYDPI;
        } else {
            var tmpNode = document.createElement("DIV");
            tmpNode.style.cssText = "width:1in;height:1in;position:absolute;left:0px;top:0px;z-index:99;visibility:hidden";
            document.body.appendChild(tmpNode);
            arrDPI[0] = parseInt(tmpNode.offsetWidth);
            arrDPI[1] = parseInt(tmpNode.offsetHeight);
            tmpNode.parentNode.removeChild(tmpNode);
        }
        return arrDPI;
    };
    /**
     * pxת��Ϊmm
     * @param value
     * @returns {number}
     */
    this.pxConversionMm = function (value) {
        var inch = value/this.conversion_getDPI()[0];
        var c_value = inch * 25.4;
//      console.log(c_value);
        return c_value;
    };
    /**
     * mmת��Ϊpx
     * @param value
     * @returns {number}
     */
    this.mmConversionPx = function (value) {
        var inch = value/25.4;
        var c_value = inch*this.conversion_getDPI()[0];
//      console.log(c_value);
        return c_value;
    }
}

//����ֱ�� new unitConversion().pxConversionMm(����) 
//        new unitConversion().mmConversionPx (����)