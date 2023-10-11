/**!
* 日期: 2023-03-06
* 作者：lixu
* 描述：本地读卡调用js函数封装【提供统一入口使用】
* 备注：1、LocalReadCardObj为读卡配置对象，ReadInsuCardInfo为配置的DLL函数名，返回对象，值放入rtn中(和基础平台保持一致)
*       2、此处以集成读医保卡功能为例
*/
//需引用js的对象
var LocalReadCardJsObj={
    "InsuCard":"../scripts/DHCInsuPort.js"        //医保卡
}
$.each(LocalReadCardJsObj, function (name, value) {
    if ($("script[src='"+value+"']").length < 1) {
        var script = document.createElement('script');
        script.type = 'text/javaScript';
        script.src = value;
        document.getElementsByTagName('head')[0].appendChild(script);
    }
})
//读卡方法都需集中在此对象中
var LocalReadCardObj = {
    ReadInsuCardInfo: function () {
        //调用医保组方法读医保卡
        var PatInfo = "-1^读卡失败"
        var rtn = InsuReadCard("0", session['LOGON.CTLOCID'], "", "03", "00A^^^");
        var InsuArr = rtn.split("|");
        if (InsuArr[0] == "0") {
            var InfoArr = InsuArr[1].split("^");
            var PatObj = {};
            PatObj.PatYBCode = InfoArr[1];			//医保卡号
            PatObj.Name = InfoArr[3];
            PatObj.Sex = InfoArr[4];
            PatObj.Age = ""; //InfoArr[5];		    //不是当前年龄，通过出生日期计算
            PatObj.Birth = InfoArr[6];
            PatObj.CredNo = InfoArr[7];				//身份证号
            var xmlhelper = new ObjToXmlHelper();
            var XMLInfo = xmlhelper.parseToXML(PatObj, "IDRoot");
            PatInfo = "0^" + InfoArr[7] + "^^" + XMLInfo;
        }
        return { "rtn": PatInfo }
    }
}

/*
*将对象转换为xml，暴露为对象，按需使用
*@obj 目标对象
*@rootname 节点名称
*@arraytypes 配置数组字段子元素的节点名称
*/
var ObjToXmlHelper = function () {
    var _arrayTypes = {}
    var _self = this;

    this.parseToXML = function (obj, rootname, arraytypes) {
        if (arraytypes) {
            _arrayTypes = arraytypes;
        }
        var xml = "";
        if (typeof obj !== "undefined") {
            if (Array.isArray(obj)) {
                xml += parseArrayToXML(obj, rootname);
            } else if (typeof obj === "object") {
                xml += parseObjectToXML(obj, rootname);
            } else {
                xml += parseGeneralTypeToXML(obj, rootname);
            }
        }
        return xml;
    }
    var parseObjectToXML = function (obj, rootname) {
        if (typeof rootname === "undefined" || !isNaN(Number(rootname))) {
            rootname = "Object";
        }
        var xml = "<" + rootname + ">";
        if (obj) {
            for (var field in obj) {
                var value = obj[field];
                if (typeof value !== "undefined") {
                    if (Array.isArray(value)) {
                        xml += parseArrayToXML(value, field);
                    } else if (typeof value === "object") {
                        xml += _self.parseToXML(value, field);
                    } else {
                        xml += parseGeneralTypeToXML(value, field);
                    }
                }
            }
        } xml += "</" + rootname + ">";
        return xml;
    }
    var parseArrayToXML = function (array, rootname) {
        if (typeof rootname === "undefined" || !isNaN(Number(rootname))) {
            rootname = "Array";
        }
        var xml = "<" + rootname + ">";
        if (array) {
            var itemrootname = _arrayTypes[rootname]; array.forEach(function (item) {
                xml += _self.parseToXML(item, itemrootname);
            });
        } xml += "</" + rootname + ">";
        return xml;
    }
    var parseGeneralTypeToXML = function (value, rootname) {
        if (typeof rootname === "undefined" || !isNaN(Number(rootname))) {
            rootname = typeof value;
        }
        var xml = "<" + rootname + ">" + value + "</" + rootname + ">";
        return xml;
    }
}
