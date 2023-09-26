/**
 * 名称:	 处方点评-数据集集合
 * 编写人:	 MaYuqiang
 * 编写日期: 2019-05-06
 */
var PRC_STORE = {
    Url: $URL + "?ResultSetType=Array&",	
    // 点评方式
    PCNTSWay: function (type,wayType) {
		return {
            url: this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSWayStore&Type=" + type +"&WayType=" + wayType
        }
    },
	// 点评管制分类(抗菌药物级别)
    PCNTSAntiLevel: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSCtrlStore"
    },
	// 处方点评管制分类
    PCNTSPoison: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSPoisonStore"
    },
	// 点评药师 
    PhaUser: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectPharmacist"   
    },
	// 不合理警示值 
    Factor: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSFactorStore"   
    },
	// 药师建议 
    PhaAdvice: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectAdviceStore"   
    },
	// 草药处方剂型 
    HerbForm: function () { 
		return {
            url: this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectHerbForm"
        }
    },
	// 手术切口类型
    BldType: function () { 
		return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectBldTypeStore"
    },
	// 手术名称
    Operation: function (bldIdStr,qText) { 
		return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectOrcOperStore&BldIdStr=" + bldIdStr + "&qText=" + qText
    },
	// 润乾背景
    RunQianBG: "../csp/dhcst.blank.backgroud.csp",
	
	

}

var PRCPRINT = ({
	/// 修改为润乾raq路径,注意同时引入润乾文件
    /// _option.raqName:   润乾文件名
    /// _options.raqParams:参数信息
    /// _options.isPreview:是否预览(1:是)
    /// _options.isPath:   是否仅获取路径(1:是)
    RaqPrint: function(_options) {
        var raqName = _options.raqName;
        var raqParams = _options.raqParams;
        var isPreview = _options.isPreview;
        var isPath = _options.isPath;
        var raqSplit = (isPreview == 1 ? "&" : ";");
        var fileName = "";
        var params = "";
        var paramsI = 0;
        for (var param in raqParams) {
            var iParam = raqParams[param];
            var iParamStr = param + "=" + iParam;
            if (paramsI == 0) {
                params = iParamStr;
            } else {
                params = params + raqSplit + iParamStr;
            }
            paramsI++;
        }
        var rqDTFormat = this.RQDTFormat();
        if (isPreview == 1) {
            fileName = raqName + "&RQDTFormat=" + rqDTFormat + "&" + params;
            if (isPath == 1) {
                return "dhccpmrunqianreport.csp?reportName=" + fileName;
            } else {
                DHCCPM_RQPrint(fileName, window.screen.availWidth * 0.5, window.screen.availHeight);
            }
        } else {
            fileName = "{" + raqName + "(" + params + ";RQDTFormat=" + rqDTFormat + ")}";
            DHCCPM_RQDirectPrint(fileName);
        }
    },
    // 系统日期格式,润乾打印用
    RQDTFormat: function() {
        var dateFmt = "yyyy-MM-dd"
        var fmtDate = $.fn.datebox.defaults.formatter(new Date());
        if (fmtDate.indexOf("/") >= 0) {
            dateFmt = "dd/MM/yyyy"
        }
        return dateFmt ;
    }
});