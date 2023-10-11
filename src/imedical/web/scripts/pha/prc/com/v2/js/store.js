/**
 * 名称:	 处方点评-数据集集合
 * 编写人:	 MaYuqiang
 * 编写日期: 2019-05-06
 */
PHA_COM.ResizePhaColParam.auto = false;		//自动调整pha-col对齐（false不调整）

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
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSCtrlStore&hospID=" + PHA_COM.Session.HOSPID; 
    },
	// 处方点评管制分类
    PCNTSPoison: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSPoisonStore&hospID=" + PHA_COM.Session.HOSPID; 
    },
	// 点评药师 
    PhaUser: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectPharmacist&hospID=" + PHA_COM.Session.HOSPID;   
    },
	// 不合理警示值 
    Factor: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=PCNTSFactorStore&hospID=" + PHA_COM.Session.HOSPID;   
    },
	// 药师建议 
    PhaAdvice: function () {
        return this.Url + "ClassName=PHA.PRC.Com.Store&QueryName=SelectAdviceStore&hospID=" + PHA_COM.Session.HOSPID;   
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
    // 医院下拉框
	AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            $($('body>.hisui-layout')[0]).layout('add', {
                region: 'north',
                border: false,
                height: 40,
                split: false,
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel">'+$g("医院")+'</label>' +
                    '       </div>' +
                    '   	<div class="pha-col">' +
                    '       	<input id="_HospList" class="textbox"/>' +
                    '   	</div>' +
                    '	</div>' +
                    '</div>'
            });
            var genHospObj = GenHospComp(tableName);
            return genHospObj;
        } else {
            return '';
        }
    }
	

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
                if (typeof websys_writeMWToken !== 'undefined') {
                    return websys_writeMWToken("dhccpmrunqianreport.csp?reportName=" + fileName);
                }
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

function InitSetPatInfo(type){
    if (typeof type === "undefined"){
        var type = "";
    }
    if (type === "I"){
        var emptyMsg = $g("请先选择一个病历");
    } else {
        var emptyMsg = $g("请先选择一个处方");
	}
	$('#patImg').attr("class", "pic-pat-unknown-gender");
    $('#patText').width($('#patText').parent().parent().width() - 45);
    $('#patText').text(emptyMsg);
}

function LoadPatInfo(rowData){
    var patordinfo='';
    var prescNo = rowData.prescNo ;
    var patNo = rowData.patNo ;
    var patName = rowData.patName ;
    var sexDesc = rowData.sexDesc ;
    var patAge = rowData.patAge ;
    var typeDesc = rowData.typeDesc ;		//患者费别
    var doclocDesc = rowData.doclocDesc ;	//就诊科室
    var patDiag = "诊断："+rowData.diag ;	//患者诊断
    var imageid="";
    if (sexDesc=="女"){  
        imageid="pic-pat-woman";
    }else if (sexDesc=="男"){
        imageid="pic-pat-man";
    }else{
        imageid="pic-pat-unknown-gender";
    }
           
    patordinfo = patName + delimiter();
    patordinfo += prescNo ? prescNo + delimiter() : "";
    patordinfo += patNo + delimiter();
    patordinfo += $g(sexDesc) + delimiter();
    patordinfo += patAge + delimiter();
    patordinfo += $g(typeDesc) + delimiter();
    patordinfo += doclocDesc + delimiter();
    patordinfo += '<span id="patDiag">'+ patDiag +'</span>';
    $('#patImg').attr("class", imageid);

    $('#patText').html(patordinfo);

	$("#patDiag").tooltip({
        content: $("#patDiag").text(),
        position: 'bottom',
        showDelay: 500
	});
}

function delimiter(){
    return '<span style="color:#bbb;">&nbsp;&nbsp;/&nbsp;&nbsp;</span>';
}