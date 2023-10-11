/// 草药业务公共js
$(function() {
    GetPhaHisCommonParmas();
});

//@description 获取his信息的公共变量参数
//@params 登记号长度,卡号长度
function GetPhaHisCommonParmas() {
    $.ajax({
        type: "POST", //提交方式 post 或者get
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPhaHisCommonParmas",
        data: "json",
        success: function(data) {
            var jsondata = JSON.parse(data); // data需要双引号
            var hisPatNoLen = jsondata[0].patNoLen;
            if (hisPatNoLen > 0) {
                DHCPHA_CONSTANT.DEFAULT.PATNOLEN = hisPatNoLen;
            }
        },
        error: function() {
            alert("获取公共参数失败!");
        }
    });
}

//监听两次回车是否太快
function KeyDownListener() {
    var keydowndate = new Date();
    var keydowntime = keydowndate.getTime();
    if (DHCPHA_CONSTANT.VAR.LASTENTERTIME != "" && DHCPHA_CONSTANT.VAR.LASTENTERTIME != undefined) {
        var minustime = keydowntime - DHCPHA_CONSTANT.VAR.LASTENTERTIME;
        if (minustime < 600) {
            alert("回车速度太快!");
        }
    }
    DHCPHA_CONSTANT.VAR.LASTENTERTIME = keydowntime;
}


// 修改csp路径为完整路径
function ChangeCspPathToAll(pathcsp) {
    var pathname = window.location.pathname;
    pathname = pathname.split("/csp/")[0];
    pathcsp = pathname + "/csp/" + pathcsp;
    return pathcsp;
}


//@description 获取病人医嘱信息,加载信息到指定div
//@params 医嘱id
function AppendPatientOrdInfo(_options) {
	var prescNo = _options.prescNo ;
	var addInfoData = tkMakeServerCall("PHA.HERB.Com.Method","GetAdmInfo",prescNo);
	var patInfo = addInfoData.split("$$")[0] ;
	var patInfoData = patInfo.split("^") ;
	var admInfo = addInfoData.split("$$")[1] ;
	var admInfoData = admInfo.split("^") ;
	/*
	if ($(_options.id)) {
		$(_options.id).remove();
	}
	*/
	$(_options.id).empty();
	var patordinfo='';
	var patNo = patInfoData[0] ;
	var patName = patInfoData[1] ;
	var sexDesc = patInfoData[2] ;
	var patAge = patInfoData[3] ;
	var typeDesc = admInfoData[1] ;		//患者费别
	var doclocDesc = admInfoData[0] ;	//就诊科室
	var patDiag = "诊断："+ admInfoData[2] ;			//患者诊断
	
	var imageid="";
	if (sexDesc=="女"){  //非女即男
		imageid="icon-female.png";
	}else if (sexDesc=="男"){
		imageid="icon-male.png";
	}else{
		imageid="icon-unmale.png";
	}
				
	patordinfo='<span>'+prescNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
	patordinfo=patordinfo+'<span>'+patNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
	patordinfo=patordinfo+'<span>'+sexDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
	patordinfo=patordinfo+'<span>'+patAge+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
	patordinfo=patordinfo+'<span>'+typeDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
	patordinfo=patordinfo+'<span>'+doclocDesc+'&nbsp;&nbsp;</span>'+'&nbsp;&nbsp;';
	
	var pathtml=""
	pathtml+='<div style="position: absolute;top: 0px;left: 0px;">'
		pathtml+='<img src=/imedical/web/scripts/pharmacy/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">';
	pathtml+='</div>';	
	pathtml+='<div style="padding-left:60px">'
		pathtml+='<div style="line-height:25px;padding-top:0px">';
			pathtml+='<span style="font-size:14px;">'+patName+'&nbsp;&nbsp;&nbsp;</span>'+patordinfo;
		pathtml+='</div>';
		pathtml+='<div style="line-height:25px">';
			pathtml+='<span>'+patDiag+'</span>'
		pathtml+='</div>';
	pathtml+='</div>';
	pathtml+='</div>';
	
	$(_options.id).append(pathtml);			
}


/**
 来自 scripts/pharmacy/common/js/dhcpha.common.js
 * 处方审核拒绝原因选择,内容Load csp,如进入系统已经加载过,则之后不会重复加载
 */
function ShowPHAPRASelReason(paramOpts, callBack, origOpts) {
    var reasonURL = ChangeCspPathToAll("pha.pra.v1.selreason.csp");
    var wayId = paramOpts.wayId || "";
    var oeori = paramOpts.oeori || "";
    var prescNo = paramOpts.prescNo || "";
    var selType = paramOpts.selType || "";
    var orderRequired = paramOpts.orderRequired || "1";
    
    if (top.$("#PHA_PRA_V1_SELREASON").html() != undefined) {
        top.$("#PHA_PRA_V1_SELREASON").panel("options").onBeforeClose = DoReturn;
        top.$("#PHA_PRA_V1_SELREASON").window("open");
        // 如果不是重新加载,则重新修改内容
        var reasonFrm;
        var frms = top.frames;
        for (var i = frms.length - 1; i >= 0; i--) {
            if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                reasonFrm = frms[i];
                break;
            }
        }
        reasonFrm.PRA_WAYID = wayId;
        reasonFrm.PRA_OEORI = oeori;
        reasonFrm.PRA_PRESCNO = prescNo;
        reasonFrm.PRA_SELTYPE = selType;
        reasonFrm.PRA_ORDERREQUIRED = orderRequired;
        reasonFrm.ReLoadPRASelReason();
        return;
    }
    websys_showModal({
        id: "PHA_PRA_V1_SELREASON",
        url: reasonURL + "?oeori=" + oeori + "&wayId=" + wayId + "&selType=" + selType + "&prescNo=" + prescNo+ "&orderRequired=" + orderRequired,
        title: "拒绝原因选择与录入",
        iconCls: "icon-w-list",
        width: "80%",
        height: "80%",
        closable: false,
        onClose: function() {}, // 不能去掉,否则默认销毁窗体
        onBeforeClose: DoReturn
    });
    function DoReturn() {
        var reasonStr = "";
        if (top) {
            var reasonFrm;
            var frms = top.frames;
            for (var i = frms.length - 1; i >= 0; i--) {
                if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
                    reasonFrm = frms[i];
                    break;
                }
            }
            if (reasonFrm != "") {
                var reasonStr = reasonFrm.PRA_SELREASON_RET;
            }
        }
        callBack(reasonStr, origOpts);
    }
}

/**
 *	草药配送信息选择框,内容Load csp,如进入系统已经加载过,则之后不会重复加载
 *	MaYuqiang 20211125
 */
function ShowDeliveryDiag(paramOpts, callBack) {
	var deliveryURL = ChangeCspPathToAll("pha.herb.v2.delivery.csp");
	var prescNo = paramOpts.prescNo || "";
	var prescForm = paramOpts.prescForm || "";
	var papmi = paramOpts.papmi || "";
	/*
	if (top.$("#PHA_HERB_V2_DELIVERY").html() != undefined) {
		top.$("#PHA_HERB_V2_DELIVERY").panel("options").onBeforeClose = DoHerbRet;
		top.$("#PHA_HERB_V2_DELIVERY").window("open");
		// 如果不是重新加载,则重新修改内容
		var deliveryFrm;
		var frms = top.frames;
		for (var i = frms.length - 1; i >= 0; i--) {
			if (frms[i].TRELOADPAGE == "pha.herb.v2.delivery.csp") {
				deliveryFrm = frms[i];
				break;
			}
		}
		deliveryFrm.DY_PRESCNO = prescNo;
		deliveryFrm.DY_PRESCFORM = prescForm;
		deliveryFrm.DY_PAPMI = papmi;
		deliveryFrm.ReLoadDeliveryWin();
		return;
	}
	*/
	websys_showModal({
		id: "PHA_HERB_V2_DELIVERY",
		url: deliveryURL + "?gPrescNo=" + prescNo + "&gPrescForm=" + prescForm+ "&gPapmi=" + papmi,
		title: "配送信息",
		iconCls: "icon-w-list",
		width: "55%",
		height: "90%",
		closable: false,
		onClose: function () {}, // 不能去掉,否则默认销毁窗体
		onBeforeClose: DoHerbRet
	});
	function DoHerbRet() {
		var deliveryStr = "";
		if (top) {
			var deliveryFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.herb.v2.delivery.csp") {
					deliveryFrm = frms[i];
					break;
				}
			}
			if (deliveryFrm != "") {
				var deliveryStr = deliveryFrm.HERB_DELIVERY_RET;
			}
		}
		callBack(deliveryStr);
		
	}
}

/**
 *	草药处方煎药费补录选择框,内容Load csp,如进入系统已经加载过,则之后不会重复加载
 *	MaYuqiang 20221020
 */
 function ShowAddCookFeeDiag(paramOpts, callBack) {
	var addCookFeeURL = ChangeCspPathToAll("pha.herb.v2.addcookfee.csp");
	var prescNo = paramOpts.prescNo || "";
	var cookTypeId = paramOpts.cookType || "";
	
	websys_showModal({
		id: "PHA_HERB_V2_ADDCOOKFEE",
		url: addCookFeeURL + "?gPrescNo=" + prescNo + "&gCookTypeId=" + cookTypeId,
		title: "补录煎药费",
		iconCls: "icon-w-list",
		width: 432,
		height: "40%",
		closable: false,
		onClose: function () {}, // 不能去掉,否则默认销毁窗体
		onBeforeClose: AddCookFeeRet
	});
	function AddCookFeeRet() {
		var cookFeeStr = "";
		if (top) {
			var addCookFeeFrm;
			var frms = top.frames;
			for (var i = frms.length - 1; i >= 0; i--) {
				if (frms[i].TRELOADPAGE == "pha.herb.v2.addcookfee.csp") {
					addCookFeeFrm = frms[i];
					break;
				}
			}
			if (addCookFeeFrm != "") {
				var cookFeeStr = addCookFeeFrm.HERB_ADDCOOKFEE_RET;
			}
		}
		callBack(cookFeeStr);
		
	}
}

/**
 *	草药处方煎药方式转换选择框,内容Load csp,如进入系统已经加载过,则之后不会重复加载
 *	MaYuqiang 20230113
*/
function ShowChangeCookType(winId, _fn){
    var $widow = $('#' + winId);
    var id = winId + "sel-cooktype"
    var storeUrl = PHA_HERB_STORE.CookType(encodeURI(PHAHERB_COM.Default.selCookTypeDesc), gLocId).url;
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId ).dialog('open');
        return
    }

    var marLeft = 10;
	var idText = $g("煎药方式")
	
    var htmlStr = '<div class = "pha-row" style="margin-top:28px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+idText+'</div>'     
            +           '<div class="pha-col" style="margin-left:0px"><input id = "'+id+'" class = "hisui-combobox" ></div>'
            + '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:  "请选择" + idText,
        width: 300, 
        height: 160,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'确定',
            handler:function(){
                var cookTypeId = $("#"+id).combobox("getValue")||""
                if(cookTypeId == ""){
                    $.messager.alert('提示', "请选择"+idText, 'error');
                    return
                }
                var retJson = {cookTypeId:cookTypeId,cookTypeDesc:$("#"+id).combobox("getText")||""}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'关闭',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
        onOpen: function(){
            // 煎药方式
            PHA.ComboBox(id,{
                editable:false, 
                url: PHA_HERB_STORE.CookType(encodeURI(PHAHERB_COM.Default.selCookTypeDesc), gLocId).url,
                onLoadSuccess: function(){
                    var data = $("#"+id).combobox('getData');
                    if (data.length == 1) {
                        //如果仅有一条数据的话默认选中第一条数据
                        $("#"+id).combobox('select', data[0].RowId);
                    }
        
                }
            });
        }
    }); 
    $('#'+ winId ).dialog('open');
}


/**
 *	草药处方置可退原因框,如进入系统已经加载过,则之后不会重复加载
 *	MaYuqiang 20230131
*/
function ShowAgreeRetWin(winId, _fn){
    var $widow = $('#' + winId);
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId ).dialog('open');
        return
    }

    var marLeft = 10;
	// class="phaherb-textarea"
    var htmlStr = '<div style="padding:20px;margin-top:10px;text-align:center;height:42px;" >'   
            +           '<textarea id="agrretremark" style="width:220px;border-radius:2px;"> </textarea>'
            +     '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:  "请填写可退原因",
        width: 300, 
        height: 180,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'确定',
            handler:function(){
                var agreeRetRemark = $.trim($("#agrretremark").val()) ;
                if(agreeRetRemark == ""){
                    $.messager.alert('提示', "请填写可退原因", 'error');
                    return
                }
                var retJson = {agreeRetRemark:agreeRetRemark}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'关闭',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
        onOpen: function(){
            $("#agrretremark").val("")
        }
    }); 
    $('#'+ winId ).dialog('open');
}

//@description 数字补0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if (inputNumLen > numLength) {
		$.messager.alert('提示',"输入错误!","info");
        return "";
    }
    for (var i = 0; i < inputNumLen; i++) {
        var para = inputNum[i];
        if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
            $.messager.alert('提示',"输入错误!","info");
            return "";
        }
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}

var HERB ={
	// 草药房医院窗体
    AddHospCom: function (_options, _pluginOptions) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            if ($('#_HospList').length == 0) {
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
                        '           <label id="_HospListLabel" style="color:red;">' +
                        $g('医院') +
                        '</label>' +
                        '       </div>' +
                        '       <div class="pha-col">' +
                        '           <input id="_HospList" class="textbox"/>' +
                        '       </div>' +
                        '   </div>' +
                        '</div>'
                });
            }
            var defHosp = $.cm(
                {
                    dataType: 'text',
                    ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
                    MethodName: 'GetDefHospIdByTableName',
                    tableName: 'tableName',
                    HospID: session['LOGON.HOSPID']
                },
                false
            );
            HospId = defHosp;

            var genHospObj = GenHospComp(tableName, '', _pluginOptions || {});
            return genHospObj;
        } else {
            return '';
        }
    },
    Grid: {
        RowStyler: {
            PersonAlt: function (index, rowData) {
                if (rowData.TaltFlag === 'Y') {
                    return {
                        class: 'datagrid-row-alt'
                    };
                }
            }
        }

    }
	
	
}

