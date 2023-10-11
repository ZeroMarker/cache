/// ��ҩҵ�񹫹�js
$(function() {
    GetPhaHisCommonParmas();
});

//@description ��ȡhis��Ϣ�Ĺ�����������
//@params �ǼǺų���,���ų���
function GetPhaHisCommonParmas() {
    $.ajax({
        type: "POST", //�ύ��ʽ post ����get
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + "?action=GetPhaHisCommonParmas",
        data: "json",
        success: function(data) {
            var jsondata = JSON.parse(data); // data��Ҫ˫����
            var hisPatNoLen = jsondata[0].patNoLen;
            if (hisPatNoLen > 0) {
                DHCPHA_CONSTANT.DEFAULT.PATNOLEN = hisPatNoLen;
            }
        },
        error: function() {
            alert("��ȡ��������ʧ��!");
        }
    });
}

//�������λس��Ƿ�̫��
function KeyDownListener() {
    var keydowndate = new Date();
    var keydowntime = keydowndate.getTime();
    if (DHCPHA_CONSTANT.VAR.LASTENTERTIME != "" && DHCPHA_CONSTANT.VAR.LASTENTERTIME != undefined) {
        var minustime = keydowntime - DHCPHA_CONSTANT.VAR.LASTENTERTIME;
        if (minustime < 600) {
            alert("�س��ٶ�̫��!");
        }
    }
    DHCPHA_CONSTANT.VAR.LASTENTERTIME = keydowntime;
}


// �޸�csp·��Ϊ����·��
function ChangeCspPathToAll(pathcsp) {
    var pathname = window.location.pathname;
    pathname = pathname.split("/csp/")[0];
    pathcsp = pathname + "/csp/" + pathcsp;
    return pathcsp;
}


//@description ��ȡ����ҽ����Ϣ,������Ϣ��ָ��div
//@params ҽ��id
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
	var typeDesc = admInfoData[1] ;		//���߷ѱ�
	var doclocDesc = admInfoData[0] ;	//�������
	var patDiag = "��ϣ�"+ admInfoData[2] ;			//�������
	
	var imageid="";
	if (sexDesc=="Ů"){  //��Ů����
		imageid="icon-female.png";
	}else if (sexDesc=="��"){
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
 ���� scripts/pharmacy/common/js/dhcpha.common.js
 * ������˾ܾ�ԭ��ѡ��,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
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
        // ����������¼���,�������޸�����
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
        title: "�ܾ�ԭ��ѡ����¼��",
        iconCls: "icon-w-list",
        width: "80%",
        height: "80%",
        closable: false,
        onClose: function() {}, // ����ȥ��,����Ĭ�����ٴ���
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
 *	��ҩ������Ϣѡ���,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
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
		// ����������¼���,�������޸�����
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
		title: "������Ϣ",
		iconCls: "icon-w-list",
		width: "55%",
		height: "90%",
		closable: false,
		onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
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
 *	��ҩ������ҩ�Ѳ�¼ѡ���,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
 *	MaYuqiang 20221020
 */
 function ShowAddCookFeeDiag(paramOpts, callBack) {
	var addCookFeeURL = ChangeCspPathToAll("pha.herb.v2.addcookfee.csp");
	var prescNo = paramOpts.prescNo || "";
	var cookTypeId = paramOpts.cookType || "";
	
	websys_showModal({
		id: "PHA_HERB_V2_ADDCOOKFEE",
		url: addCookFeeURL + "?gPrescNo=" + prescNo + "&gCookTypeId=" + cookTypeId,
		title: "��¼��ҩ��",
		iconCls: "icon-w-list",
		width: 432,
		height: "40%",
		closable: false,
		onClose: function () {}, // ����ȥ��,����Ĭ�����ٴ���
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
 *	��ҩ������ҩ��ʽת��ѡ���,����Load csp,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
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
	var idText = $g("��ҩ��ʽ")
	
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
        title:  "��ѡ��" + idText,
        width: 300, 
        height: 160,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'ȷ��',
            handler:function(){
                var cookTypeId = $("#"+id).combobox("getValue")||""
                if(cookTypeId == ""){
                    $.messager.alert('��ʾ', "��ѡ��"+idText, 'error');
                    return
                }
                var retJson = {cookTypeId:cookTypeId,cookTypeDesc:$("#"+id).combobox("getText")||""}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'�ر�',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
        onOpen: function(){
            // ��ҩ��ʽ
            PHA.ComboBox(id,{
                editable:false, 
                url: PHA_HERB_STORE.CookType(encodeURI(PHAHERB_COM.Default.selCookTypeDesc), gLocId).url,
                onLoadSuccess: function(){
                    var data = $("#"+id).combobox('getData');
                    if (data.length == 1) {
                        //�������һ�����ݵĻ�Ĭ��ѡ�е�һ������
                        $("#"+id).combobox('select', data[0].RowId);
                    }
        
                }
            });
        }
    }); 
    $('#'+ winId ).dialog('open');
}


/**
 *	��ҩ�����ÿ���ԭ���,�����ϵͳ�Ѿ����ع�,��֮�󲻻��ظ�����
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
        title:  "����д����ԭ��",
        width: 300, 
        height: 180,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'ȷ��',
            handler:function(){
                var agreeRetRemark = $.trim($("#agrretremark").val()) ;
                if(agreeRetRemark == ""){
                    $.messager.alert('��ʾ', "����д����ԭ��", 'error');
                    return
                }
                var retJson = {agreeRetRemark:agreeRetRemark}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'�ر�',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
        onOpen: function(){
            $("#agrretremark").val("")
        }
    }); 
    $('#'+ winId ).dialog('open');
}

//@description ���ֲ�0
//@input: no,length
function NumZeroPadding(inputNum, numLength) {
    if (inputNum == "") {
        return inputNum;
    }
    var inputNumLen = inputNum.length;
    if (inputNumLen > numLength) {
		$.messager.alert('��ʾ',"�������!","info");
        return "";
    }
    for (var i = 0; i < inputNumLen; i++) {
        var para = inputNum[i];
        if (isNaN(para) || para.trim() == "" || String(para).indexOf(".") > -1 || !(parseInt(inputNum) > 0)) {
            $.messager.alert('��ʾ',"�������!","info");
            return "";
        }
    }
    for (var i = 1; i <= numLength - inputNumLen; i++) {
        inputNum = "0" + inputNum;
    }
    return inputNum;
}

var HERB ={
	// ��ҩ��ҽԺ����
    AddHospCom: function (_options, _pluginOptions) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
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
                        $g('ҽԺ') +
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

