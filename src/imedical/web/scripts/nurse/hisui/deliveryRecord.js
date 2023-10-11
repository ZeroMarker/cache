var dialogOpen=0;
var saveFlag=false;
var apgarMiniuteOtherOne="";
var apgarMiniuteOtherTwo="";
var apgarOne={
    activity: "2",   // ������
    appearance: "2", // ��ɫ
    grimace: "2",    // ����
    pulse: "2",      // ����
    respiration: "2", // ����
    total: "10"
}
var apgarFive={
    activity: "2",
    appearance: "2",
    grimace: "2",
    pulse: "2",
    respiration: "2",
    total: "10"
}
var apgarOtherOne={
    activity: "2",
    appearance: "2",
    grimace: "2",
    pulse: "2",
    respiration: "2",
    total: "10"
}
var apgarOtherTwo={
    activity: "2",
    appearance: "2",
    grimace: "2",
    pulse: "2",
    respiration: "2",
    total: "10"
}
$(window).resize(function(){
	ResetDomSize();
})
$(window).load(function() {
	$("#loading").hide();
})
$(function(){ 
	SetPatientBarInfo();
	initTabDeliveryRecord();
	GetMotherGP();
	initNewBabyDetailWin();
	changeNewBabyDetailItemStatus();
});
function initNewBabyDetailWin(){
	var curDateTime = $cm({ClassName: "Nur.NIS.Common.SystemConfig",MethodName: "GetCurrentDateTime",timeFormat: "2"},false)
	for (var i=0;i<ServerObj.newBabyDetailObj.length;i++){
		for (var j=0;j<ServerObj.newBabyDetailObj[i].length;j++){
			var itemAticve=ServerObj.newBabyDetailObj[i][j].itemAticve;
			if (itemAticve=="N") continue;
			var itemId=ServerObj.newBabyDetailObj[i][j].itemId;
			var itemType=ServerObj.newBabyDetailObj[i][j].itemType;
			var itemData=ServerObj.newBabyDetailObj[i][j].itemData;
			var itemDefaultValue=ServerObj.newBabyDetailObj[i][j].itemDefaultValue;
			var itemRequired=ServerObj.newBabyDetailObj[i][j].itemRequired;
			var itemDisplayOnlyLiveBirth=ServerObj.newBabyDetailObj[i][j].itemDisplayOnlyLiveBirth;
			if (itemDisplayOnlyLiveBirth=="Y"){
				$("#"+itemId).parent().hide();
				$("label[for='"+itemId+"']").parent().hide();
			}
			if (itemType==1 || itemType==2){
				$HUI.combobox("#"+itemId,{
		            valueField:'id',
		            textField:'desc',
		            required:itemRequired=="Y"?true:false,
		            multiple:itemType==2?true:false,
		            rowStyle:itemType==2?'checkbox':'', //��ʾ�ɹ�ѡ����ʽ
		            selectOnNavigation:false,
		            editable:false,
		            data:itemData,
		            onLoadSuccess:function(){
			            if(itemDefaultValue!=""){
				            if (itemType==2){
					            $("#"+itemId).combobox("setValues",itemDefaultValue.toString().split("$"));
					        }else{
						        if (itemId=="outComeCode") {
							        var outComeData=$("#"+itemId).combobox("getData")
							        var index=$.hisui.indexOfArray(outComeData,"tabId",itemDefaultValue)
							        if (index>=0){
								        $("#"+itemId).combobox("setValue",outComeData[index].id);
								    }
							    }else{
						        	$("#"+itemId).combobox("setValue",itemDefaultValue);
						        }
						    }
				        }
				        if (this.id=="name"){
					        var data=$("#name").combobox("getData");
					        if (data.length==1){
						        $("#name").combobox("setValue",data[0].id);
						    }
					    }
			        },
			        onChange:function(newValue, oldValue){
				        // ���䷽ʽ���������ı�ʱ���Զ��ı�������Ŀ������
				        if ((this.id=="outComeCode")||(this.id=="birthType")){
					        changeNewBabyDetailItemStatus();
					    }
					    // �����������ֶ�ģʽʱ,ѡ���Ա�������Ӧ�������б�
					    if ((this.id=="outComeCode")&&(getLiveBirthFlag()=="Y")&&(ServerObj.deliveryOtherSetObj.babyGenerateRule=="Manual")){
						    loadBabyName();
						}
						if (this.id=="name"){
							if (ServerObj.deliveryOtherSetObj.babyGenerateRule=="Manual"){
								var data=$("#name").combobox("getData");
								var index=$.hisui.indexOfArray(data,"id",newValue);
								if (index>=0){
									$("#sex").combobox("setValue",data[index].babyNameLimitSex);
								}
							}
							updateName2();
						}
						if (this.id=="sex"){
							if (ServerObj.deliveryOtherSetObj.babyGenerateRule=="Manual"){
								if ((newValue!=oldValue)) loadBabyName(); //&&(oldValue!="")
							}else{
								autoSetBabyName();
							}
						}
				    },
				    onHidePanel:function(){
					    if (this.id=="name") updateName2();
					}
		        });
			}else if(itemType==3){
				$("#"+itemId).val(itemDefaultValue);
			}else if(itemType==4){
				$("#"+itemId).datebox("setValue",itemDefaultValue);
			}else if(itemType==5){
				$("#"+itemId).timespinner("setValue",itemDefaultValue);
			}else if(itemType==6){
				$("#"+itemId).numberbox("setValue",itemDefaultValue);
			}
			if (itemId=="birthDate"){
				$("#birthDate").datebox("setValue",curDateTime.date);
			}
			if (itemId=="birthTime"){
				$("#birthTime").timespinner("setValue",curDateTime.time);
			}
		}
	}
	initApgarPopover();
}
function changeNewBabyDetailItemStatus(){
	var liveBirthFlag=getLiveBirthFlag();
	var outComeCode=$("#outComeCode").combobox("getValue");
	var birthType=$("#birthType").combobox("getValues");
	for (var i=0;i<ServerObj.newBabyDetailObj.length;i++){
		for (var j=0;j<ServerObj.newBabyDetailObj[i].length;j++){
			var itemAticve=ServerObj.newBabyDetailObj[i][j].itemAticve;
			if (itemAticve=="N") continue;
			var itemId=ServerObj.newBabyDetailObj[i][j].itemId;
			if (("^birthType^outComeCode^birthDate^birthTime^").indexOf("^"+itemId+"^")>=0) continue;
			var itemDisplayOnlyLiveBirth=ServerObj.newBabyDetailObj[i][j].itemDisplayOnlyLiveBirth;
			var itemDeliveryMethods=ServerObj.newBabyDetailObj[i][j].itemDeliveryMethods;
			var deliveryMethodFlag="N";
			if (birthType.length==0){
				deliveryMethodFlag="Y";
			}else{
				if (itemDeliveryMethods=="") deliveryMethodFlag="Y";
				else {
					for (var m=0;m<birthType.length;m++){
						if (("$"+itemDeliveryMethods+"$").indexOf("$"+birthType[m]+"$")>=0){
							deliveryMethodFlag="Y";
							break;
						}
					}
				}
			}
			if (liveBirthFlag=="Y"){
				if (deliveryMethodFlag =="Y"){ //(itemDisplayOnlyLiveBirth=="Y" || itemDisplayOnlyLiveBirth=="") &&
					$("#"+itemId).parent().show();
					$("label[for='"+itemId+"']").parent().show();
				}else{
					$("#"+itemId).parent().hide();
					$("label[for='"+itemId+"']").parent().hide();
				}
			}else if(liveBirthFlag=="N"){
				if ((itemDisplayOnlyLiveBirth=="N" || itemDisplayOnlyLiveBirth=="") && deliveryMethodFlag =="Y"){
					$("#"+itemId).parent().show();
					$("label[for='"+itemId+"']").parent().show();
				}else{
					$("#"+itemId).parent().hide();
					$("label[for='"+itemId+"']").parent().hide();
				}
			}else{
				$("#"+itemId).parent().hide();
				$("label[for='"+itemId+"']").parent().hide();
			}
		}
	}
	ChangeNewBabyDetailTable_TrStatus();
}
function ChangeNewBabyDetailTable_TrStatus(){
	var trs=$("#newBabyDetailTable tr");
	for (var i=0;i<trs.length;i++){
		if ($(trs[i]).height()==0){
			$(trs[i]).hide();
		}else{
			$(trs[i]).show();
		}
	}
	changeNewBabyDetailDialogPosition();
}
function changeNewBabyDetailDialogPosition(){
	var width=$("#newBabyDetailTable").width()+10;
	var height=$("#newBabyDetailTable").height()+37+50;
	var maxHeight=740;
	if (height>maxHeight) {
		height=maxHeight;
		width=width+15;
	}
	if (dialogOpen==1){
		$("#newBabyDetailDialog").dialog({
			width:width,
		    height: height,
		 }).dialog('open');
		 var liveBirthFlag=getLiveBirthFlag();
		 if (liveBirthFlag=="N"){
			$("#savePrint").hide();
		 }else{
			 $("#savePrint").show();
	     }
     }
}
function showNewBabyDetailWin(){
	if (ServerObj.deliveryOtherSetObj.noRegisterNoAddRecord=="Y"){
		var deliveryStatus = $m({ClassName: "Nur.IP.Delivery",MethodName: "getCurrentDeliveryStatus",EpisodeID: ServerObj.EpisodeID},false);
		if (deliveryStatus=="" || deliveryStatus=="C"){
			$.messager.popover({msg: 'δ���з���Ǽǻ���ȡ������Ǽ�,�������������¼��',type:'error'});
			return false;
		}
	}
	var rows=$('#tabDeliveryRecord').datagrid("getRows");
	if (pregnancyNumber==""){
		$.messager.popover({msg: '����ά����̥����',type:'error'});
		$("#pregnancyNumber").focus();
		return false;
	}else if (rows.length==pregnancyNumber){
		$.messager.popover({msg: '��ά���ͻ�̥����ͬ�ķ����¼����',type:'error'});
		return false; 
	}
    $("#newBabyDetailDialog").dialog({
	    iconCls:'icon-w-add',
	    modal:true,
        buttons:[{
            text:'����',
            handler:function(){
            	save("");
            }
        },{
	        id:"savePrint",
            text:'���沢��ӡ���',
            handler:function(){
            	save("",printIntercept);
            }
        },{
            text:'ȡ��',
            handler:function(){$HUI.dialog('#newBabyDetailDialog').close();}
        }],
        onBeforeClose:function(){
	        dialogOpen=0;
	        initNewBabyDetailWin();
	        changeNewBabyDetailItemStatus();
	    }
  })
  //$('#newBabyDetailDialog').dialog('open');
  dialogOpen=1;
  ChangeNewBabyDetailTable_TrStatus();
  initForm("");
}
function initTabDeliveryRecord(){
	$('#tabDeliveryRecord').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : true,
		titleNoWrap:false,
		idField:"pregDelBabyID",
		autoRowHeight:true,
		toolbar: [{
			iconCls: 'icon-add',
			text: '����',
			handler: function() {
				showNewBabyDetailWin('add')
			}
		},{
			iconCls: 'icon-edit',
			text: '�޸�',
			handler: function() {
				var row=$('#tabDeliveryRecord').datagrid("getSelected");
				if (!row){
					$.messager.popover({msg: '��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				showUpdateNewBabyDetailWin(row);
			}
		}],
		queryParams: {
			ClassName: "Nur.NIS.Service.Delivery.Record",
			QueryName: "findBaby"
		},
		url: $URL,
		className:"Nur.NIS.Service.Delivery.Record",
		queryName:"findBaby",
		onColumnsLoad:function(cm){
			for (var i=cm.length-1;i>=0;i--){
				if (cm[i].title=="hidden") cm.splice(i,1);
			}
			cm.push(
				{field:'prnWristBtn',title:'��ӡ���',align:'center',width:50,formatter:prnWristFormat,rowspan:2},   
                {field:'op',title:'����',align:'center',width:50,formatter:reWrite,rowspan:2} 
			);
		},
		onBeforeLoad:function(param){
			param.episodeID = ServerObj.EpisodeID;
			$('#tabDeliveryRecord').datagrid("unselectAll"); 
		},
		onDblClickRow:function(rowIndex, rowData){
			showUpdateNewBabyDetailWin(rowData);
		},
		onLoadSuccess:function(data){
			for (var i=0;i<ServerObj.newBabyDetailObj.length;i++){
				for (var j=0;j<ServerObj.newBabyDetailObj[i].length;j++){
					var itemId=ServerObj.newBabyDetailObj[i][j].itemId;
					var itemAticve=ServerObj.newBabyDetailObj[i][j].itemAticve;
					var itemDisplayInList=ServerObj.newBabyDetailObj[i][j].itemDisplayInList;
					if ((itemAticve=="N")||(itemDisplayInList=="N")) {
						$('#tabDeliveryRecord').datagrid("hideColumn",itemId);
					}
				}
			}
		}
	})
}
// ����ĸ���дβ���
function SaveMotherGP(){
	var PregnancyNumber=$('#pregnancyNumber').numberbox("getValue");
	var rows=$('#tabDeliveryRecord').datagrid("getRows");
	if ((rows.length>0)&&(PregnancyNumber=="")){
		$.messager.popover({msg: '��ά����̥����',type:'error'});
		$("#pregnancyNumber").focus();
		return false;
	}else if (rows.length>PregnancyNumber){
		$.messager.popover({msg: '��̥������С���ѷ����¼������',type:'error'});
		$("#pregnancyNumber").focus();
		return false; 
	}
	$m({
		ClassName: "Nur.NIS.Service.Delivery.Record",
		MethodName: "SaveMotherGP",
		motherEpisodeID: ServerObj.EpisodeID,
		gravida:$('#gravida').numberbox("getValue"),
		para:$('#para').numberbox("getValue"),
		pregnancyNumber:PregnancyNumber,
		userID:session['LOGON.USERID']
	},function(res){
		if(res == '0') {
			$.messager.popover({msg: '����ɹ���',type:'success'});
			pregnancyNumber=$('#pregnancyNumber').numberbox("getValue");
		}else $.messager.popover({msg: res,type:'alert'});
	});
}
// ��ȡĸ���дβ���
var pregnancyNumber="";
function GetMotherGP(){
    var res=tkMakeServerCall("Nur.NIS.Service.Delivery.Record","GetMotherGP",ServerObj.EpisodeID);
    var gravida="",para="";
    pregnancyNumber="";
    if(res.indexOf('^') > -1){
      gravida=res.split('^')[0];
      para=res.split('^')[1];
      pregnancyNumber=res.split('^')[2];
    }
    $('#gravida').numberbox("setValue",gravida);
  	$('#para').numberbox("setValue",para);
  	$('#pregnancyNumber').numberbox("setValue",pregnancyNumber);
}
// ���ػ�����Ϣ������
var patientListPage="";
function SetPatientBarInfo() {
	InitPatInfoBanner(ServerObj.EpisodeID);
	/*var html=$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: ServerObj.EpisodeID
	},false);
	if (html != "") {
		$(".patientbar").data("patinfo",html);
		if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
		else{$(".PatInfoItem").html(reservedToHtml(html))}
		$(".PatInfoItem").find("img").eq(0).css("top",0);
		
	} else {
		$(".PatInfoItem").html($g("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�"));
	}*/
}
function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
		return replacements[v];
	});
}
function prnWristFormat(value,row,index){
	// ֻ��"���"���ܴ�ӡ���
	if (row["outComeCode"]=="L"){
    	return "<a  href='#' onclick=printIntercept('"+row.babyEpisodeID+"')><img src='../images/uiimages/print.png' /></a>"
    }
    return "";
}
// ���²�����Ŀ���������
function reWrite(value,row,index){
    return "<a  href='#' onclick=confirmDelItem('"+row.pregDelBabyID+"')><img src='../images/uiimages/bed/cancel.png' /></a>"
}
// ɾ������
function confirmDelItem(babayId){
    $.messager.confirm("ɾ��", "ȷ��ȷ��ɾ��������?", function (r) {
        if (r) {
            //$.messager.popover({msg:"�����ȷ��",type:'info'});
            delItem(babayId)
        }
    });
}
// ɾ���߼�
function delItem(Id){
    $cm({
        ClassName:"Nur.IP.Delivery",
        MethodName:"delete",
        ID:Id, 
        userID:session['LOGON.USERID'], 
        groupDesc:session['LOGON.GROUPDESC'],
        dataType:"text"
    },function(res){
        if(res.indexOf("0") != -1){
            // ɾ���ɹ�
            $.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});
            $('#tabDeliveryRecord').datagrid("reload"); // ˢ�±������
        }else{
            // ɾ��ʧ��
            $.messager.popover({msg: res,type:'alert'});
        }
    })
}
//��ӡӤ�����
function printIntercept(episodeID) {
    var printFormworkID=$m({
		ClassName:"Nur.NIS.Service.Base.BedConfig",
		MethodName:"GetFormworkByMenuUrl",
		hospId: session['LOGON.HOSPID'],
		menuUrl: "WristStrapsinfant"
	},false)
	if (printFormworkID ==""){
		$.messager.popover({msg: "����λͼ�Ҽ���- ��Ӥ�������ӡ�� δά����ӡģ�壡",type:'alert'});
		return false;
	}
    var formwork=$cm({
		ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
		MethodName:"GetFormwork",
		sheetID: printFormworkID
	},false);
	var paraData=$m({
		ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
		MethodName:"GetPrintData",
		sheetID: printFormworkID,
		parr: episodeID,
		type: "para"
	},false);
	$m({
		ClassName:"Nur.NIS.Service.OrderExcute.XMLPrint",
		MethodName:"GetPrintData",
		sheetID: printFormworkID,
		parr: episodeID,
		type: "list"
	},function(listData){
		if (formwork.forbidReprint==="Y" && session['LOGON.GROUPDESC'].indexOf("��ʿ��") === -1) {
			console.log(session['LOGON.GROUPDESC'].indexOf("��ʿ��"));
			var printLockStatus=$m({
				ClassName:"Nur.Print.Service.PatInfoPrint",
				MethodName:"GetPrintLockStatus",
				adm: episodeID,
				wardId: session['LOGON.WARDID'],
				formworkID:printFormworkID},false);
			if (printLockStatus==="Y") {
				$.messager.popover({msg: "��ǰ�û��޲���Ȩ��!",type:'alert'});
				return false;
			}else{
				wristStrapsPrint(formwork.forbidReprint,episodeID,printFormworkID,formwork, paraData, listData);
			}
		}else{
			wristStrapsPrint(formwork.forbidReprint,episodeID,printFormworkID,formwork, paraData, listData);
		}
		
	});
}
function wristStrapsPrint(forbidReprint,episodeID,printFormworkID,formwork, paraData, listData) {
	window.NurPrtCommOutSide(formwork, paraData, listData);
	
	if (forbidReprint === "Y") {
		debugger;
		$cm({
			ClassName:"Nur.Print.Service.PatInfoPrint",
			MethodName:"InsertPrintLockChunks",	
			admStr:episodeID, 
			wardId: session['LOGON.WARDID'], 
			formworkID:printFormworkID, 
			userId:session['LOGON.USERID']		
		},function(ret){
			if (ret.status === 0) {
				$.messager.popover({msg: "��ӡ�����ɹ�",type:'success'});
			}else{
				$.messager.popover({msg: ret.errList.join(" "),type:'info'});
			}
		})
	}
}
function save(babyId,callBack){
	if (saveFlag) return;
	var saveObj={};
	var nullValueArr=[],inValidNumberArr=[];
	var reg = new RegExp("^[0-9]*$");
	var order=$("#NO").val(); // ���
	var liveBirthFlag=getLiveBirthFlag();
	for (var i=0;i<ServerObj.newBabyDetailObj.length;i++){
		for (var j=0;j<ServerObj.newBabyDetailObj[i].length;j++){
			var itemAticve=ServerObj.newBabyDetailObj[i][j].itemAticve;
			if (itemAticve=="N") continue;
			var itemId=ServerObj.newBabyDetailObj[i][j].itemId;
			var itemDesc=ServerObj.newBabyDetailObj[i][j].itemDesc;
			var itemType=ServerObj.newBabyDetailObj[i][j].itemType;
			var itemRequired=ServerObj.newBabyDetailObj[i][j].itemRequired;
			var itemDisplayOnlyLiveBirth=ServerObj.newBabyDetailObj[i][j].itemDisplayOnlyLiveBirth;
			if ($("#"+itemId).parent().css("display")=="none"){
				var value="";
			}else{
				if (itemType==1){
					//������ѡ
					var value=$("#"+itemId).combobox("getValue");
					if (itemId=="name") value=$("#"+itemId).combobox("getText");
				}else if(itemType==2){
					//������ѡ
					var value=$("#"+itemId).combobox("getValues").join("^");
				}else if(itemType==3){
					//�����ı�
					var value=$("#"+itemId).val();
				}else if(itemType==4){
					//����
					var value=$("#"+itemId).datebox("getValue");
				}else if(itemType==5){
					//ʱ��
					var value=$("#"+itemId).timespinner("getValue");
				}else if(itemType==6){
					//����
					var value=$("#"+itemId).numberbox("getValue");
					if(!reg.test(value)){
						inValidNumberArr.push(itemDesc);
					}
				}
				if ((value==="")&&(itemRequired=="Y")){
					nullValueArr.push(itemDesc);
				}
			}
			saveObj[itemId]=value;
		}
	}
	saveStr=JSON.stringify(saveObj);
	if (liveBirthFlag=="Y"){
		var jsonObj = {
	       apgarOne: apgarOne,
	       apgarFive: apgarFive,
	       apgarOtherOne: apgarOtherOne,
	       apgarOtherTwo:apgarOtherTwo,
	       apgarMiniuteOtherOne:saveObj.pfonel,
	       apgarMiniuteOtherTwo:saveObj.pftwol
	   }
	}else{
		var jsonObj = {
	       apgarOne: {},
	       apgarFive: {},
	       apgarOtherOne: {},
	       apgarOtherTwo:{},
	       apgarMiniuteOtherOne:saveObj.pfonel,
	       apgarMiniuteOtherTwo:saveObj.pftwol
	   }
	}
   jsonStr=JSON.stringify(jsonObj)

	var errMsgArr=[];
	var nullValueMsg="";
	if (nullValueArr.length>0){
		nullValueMsg=nullValueArr.join("��") +"����Ϊ�գ�";
		errMsgArr.push(nullValueMsg);
	}
	var inValidNumberMsg="";
	if (inValidNumberArr.length>0){
		nullValueMsg=inValidNumberArr.join("��") +"�����֣�";
		errMsgArr.push(nullValueMsg);
	}
	if (errMsgArr.length>0){
		$.messager.popover({msg: errMsgArr.join("</br>"),type:'error'});
        return false;
	}
	saveFlag=true;
    $cm({
        ClassName:"Nur.NIS.Service.Delivery.Record",
        MethodName:"saveBabyDeliveryInfo",
        motherEpisodeID:ServerObj.EpisodeID,
        babyID:babyId,
        orderNumber:order,
        saveJsonString:saveStr,
       	apgarJsonString:jsonStr,
       	userID:session['LOGON.USERID'],
      },function(res){
          if(res>=0){
              $HUI.dialog('#newBabyDetailDialog').close()
              $.messager.popover({msg: '����ɹ���',type:'success'});
              $("#tabDeliveryRecord").datagrid("reload");
              if (callBack) callBack(res);
          }else{
	          $.messager.popover({msg: '����ʧ�ܣ�'+res,type:'error'});
	      }
	      saveFlag=false;
      })
}
function getLiveBirthFlag(){
	var liveBirthFlag="N";
	var outComeCodeData=$("#outComeCode").combobox("getData");
	var outComeCode=$("#outComeCode").combobox("getValue");
	if (outComeCode=="") return "";
	var index=$.hisui.indexOfArray(outComeCodeData,"id",outComeCode);
	if (index<0) return liveBirthFlag;
	if (outComeCodeData[index].desc==$g("���")) liveBirthFlag="Y";
	return liveBirthFlag;
}
function initForm(babyID){
	 $cm({
        ClassName:"Nur.NIS.Service.Delivery.Record",
        MethodName:"getBabyDeliveryInfo",
        motherEpisodeID:ServerObj.EpisodeID,
        babyID:babyID
    },function(res){
	    $("#NO").val(res.orderNumber) // ����baby���
	    $("#birthDate").datebox("setValue",res.birthDate);
	    $('#birthTime').timespinner('setValue',res.birthTime);
	    if (babyID){
		    $("#outComeCode").combobox("disable");
		    $("#name").combobox("setText",res.name);
    		$("#name2").val(res.name2);
    		for (var i=0;i<ServerObj.newBabyDetailObj.length;i++){
				for (var j=0;j<ServerObj.newBabyDetailObj[i].length;j++){
					var itemAticve=ServerObj.newBabyDetailObj[i][j].itemAticve;
					if (itemAticve=="N") continue;
					var itemId=ServerObj.newBabyDetailObj[i][j].itemId;
					var itemType=ServerObj.newBabyDetailObj[i][j].itemType;
					if (itemType==1){
						$("#"+itemId).combobox("setValue",res[itemId]);
					}else if(itemType==2){
						$("#"+itemId).combobox("setValues",res[itemId].length>0?res[itemId]:"");
					}else if(itemType==3){
						$("#"+itemId).val(res[itemId]);
					}else if(itemType==4){
						$("#"+itemId).datebox("setValue",res[itemId]);
					}else if(itemType==5){
						$("#"+itemId).timespinner("setValue",res[itemId]);
					}else if(itemType==6){
						$("#"+itemId).numberbox("setValue",res[itemId]);
					}
				}
			}
		}else{
			$("#outComeCode").combobox("enable");
			if (ServerObj.deliveryOtherSetObj.babyGenerateRule!="Manual"){
				//$("#name").combobox("setText",res.name);
    			//$("#name2").val(res.name2);
			}
		}
		apgarMiniuteOtherOne= res.OtherOne ? res.OtherOne : "";
    	apgarMiniuteOtherTwo=res.OtherTwo ? res.OtherTwo : ""
    	// ��������ȡ�����޸ı�������
	    if (typeof Object.assign != 'function') {
	      // ���Object.assign������ie��֧�ֵ�����
	      Object.assign = function(target) {
	        'use strict';
	        if (target == null) {
	          throw new TypeError('Cannot convert undefined or null to object');
	        }
	     
	        target = Object(target);
	        for (var index = 1; index < arguments.length; index++) {
	          var source = arguments[index];
	          if (source != null) {
	            for (var key in source) {
	              if (Object.prototype.hasOwnProperty.call(source, key)) {
	                target[key] = source[key];
	              }
	            }
	          }
	        }
	        return target;
	      };
	  	}
    	Object.assign(apgarFive,res.apgarFive);
    	Object.assign(apgarOne,res.apgarOne);
    	Object.assign(apgarOtherOne,res.apgarOtherOne);
    	Object.assign(apgarOtherTwo,res.apgarOtherTwo);
		$("#one").val(apgarOne.total);
	    $("#five").val(apgarFive.total);
	    $("#pfoner").val(apgarOtherOne.total);
	    $("#pftwor").val(apgarOtherTwo.total);
	    $("#pfonel").numberbox("setValue",apgarMiniuteOtherOne);
	    $("#pftwol").numberbox("setValue",apgarMiniuteOtherTwo);
	})
}
function loadBabyName(){
	var order=$("#NO").val(); // ���
	if ($("#sex").parent().css("display")=="none"){
		var sex="";
	}else{
		var sex=$("#sex").combobox("getValue");
	}
	 $cm({
        ClassName:"Nur.NIS.Service.Delivery.Record",
        MethodName:"getBabyNameList",
        motherEpisodeID:ServerObj.EpisodeID,
        pregnancyNumber:pregnancyNumber,
        order:order,
        limitSex:sex,
        hospId:session['LOGON.HOSPID']
    },function(res){
	    $("#name").combobox("loadData",res);
	})
}
function autoSetBabyName(){
	var order=$("#NO").val(); // ���
	if ($("#sex").parent().css("display")=="none"){
		var sex="";
	}else{
		var sex=$("#sex").combobox("getValue");
	}
	$cm({
        ClassName:"Nur.NIS.Service.Delivery.Record",
        MethodName:"autoGetBabyName",
        motherEpisodeID:ServerObj.EpisodeID,
        order:order,
        limitSex:sex
    },function(res){
	    $("#name").combobox("setText",res.name);
	    $("#name2").val(res.name2);
	})
}
function initApgarPopover(){
	 // Apgar����(1����)
    $HUI.popover('#PoPOne',{
        title:'',
        content:"",
        width:260,
        height:160,
        backdrop:true,
        url:"#radioGrop",
        onShow:function(){
            // ��ʼ������
            $("#radioGrop").show();
            $HUI.radio("#jzl"+apgarOne.activity).setValue(true);
            $HUI.radio("#breath"+apgarOne.respiration).setValue(true);
            $HUI.radio("#mb"+apgarOne.pulse).setValue(true);
            $HUI.radio("#fs"+apgarOne.grimace).setValue(true);
            $HUI.radio("#fus"+apgarOne.appearance).setValue(true);
        },
        onHide:function(){
            // �ռ�����
            var activity=$("input[name='jzl']:checked").val()
            var respiration=$("input[name='breath']:checked").val()
            var pulse=$("input[name='mb']:checked").val()
            var grimace=$("input[name='fs']:checked").val()
            var appearance=$("input[name='fus']:checked").val()
            // �����ܷ�
            var total="";
            if(typeof(activity)!="undefined") total=parseInt(activity);
            if(typeof(respiration)!="undefined") total=total==="" ? parseInt(respiration) : total+parseInt(respiration);
            if(typeof(pulse)!="undefined") total=total==="" ? parseInt(pulse) : total+parseInt(pulse);
            if(typeof(grimace)!="undefined") total=total==="" ? parseInt(grimace) : total+parseInt(grimace);
            if(typeof(appearance)!="undefined") total=total==="" ? parseInt(appearance) : total+parseInt(appearance);
            apgarOne.activity=activity
            apgarOne.total=total
            apgarOne.respiration=respiration
            apgarOne.pulse=pulse
            apgarOne.grimace=grimace
            apgarOne.appearance=appearance
            $("#one").val(apgarOne.total);
        }
    });
    // Apgar����(5����)
    $HUI.popover('#PoPFive',{
        title:'',
        content:"",
        width:260,
        backdrop:true,
        height:160,
        url:"#FiveradioGrop",
        onShow:function(){
            // ��ʼ������
            $("#radioGrop").show();
            $HUI.radio("#Fivejzl"+apgarFive.activity).setValue(true);
            $HUI.radio("#Fivebreath"+apgarFive.respiration).setValue(true);
            $HUI.radio("#Fivemb"+apgarFive.pulse).setValue(true);
            $HUI.radio("#Fivefs"+apgarFive.grimace).setValue(true);
            $HUI.radio("#Fivefus"+apgarFive.appearance).setValue(true);
        },
        onHide:function(){
            // �ռ�����
            $("#radioGrop").hide();
            var activity=$("input[name='Fivejzl']:checked").val()
            var respiration=$("input[name='Fivebreath']:checked").val()
            var pulse=$("input[name='Fivemb']:checked").val()
            var grimace=$("input[name='Fivefs']:checked").val()
            var appearance=$("input[name='Fivefus']:checked").val()
            // �����ܷ�
            var total="";
            if(typeof(activity)!="undefined") total=parseInt(activity);
            if(typeof(respiration)!="undefined") total=total==="" ? parseInt(respiration) : total+parseInt(respiration);
            if(typeof(pulse)!="undefined") total=total==="" ? parseInt(pulse) : total+parseInt(pulse);
            if(typeof(grimace)!="undefined") total=total==="" ? parseInt(grimace) : total+parseInt(grimace);
            if(typeof(appearance)!="undefined") total=total==="" ? parseInt(appearance) : total+parseInt(appearance);
            apgarFive.activity=activity
            apgarFive.total=total
            apgarFive.respiration=respiration
            apgarFive.pulse=pulse
            apgarFive.grimace=grimace
            apgarFive.appearance=appearance
            $("#five").val(apgarFive.total);
        }
    });
    // otherOne
    $HUI.popover('#OtherOne',{
        title:'',
        content:"",
        width:260,
        backdrop:true,
        height:160,
        url:"#OTOneradioGrop",
        onShow:function(){
            // ��ʼ������
            $("#radioGrop").show();
            $HUI.radio("#OTOnejzl"+apgarOtherOne.activity).setValue(true);
            $HUI.radio("#OTOnebreath"+apgarOtherOne.respiration).setValue(true);
            $HUI.radio("#OTOnemb"+apgarOtherOne.pulse).setValue(true);
            $HUI.radio("#OTOnefs"+apgarOtherOne.grimace).setValue(true);
            $HUI.radio("#OTOnefus"+apgarOtherOne.appearance).setValue(true);
        },
        onHide:function(){
            // �ռ�����
            $("#radioGrop").hide();
            var activity=$("input[name='OTOnejzl']:checked").val()
            var respiration=$("input[name='OTOnebreath']:checked").val()
            var pulse=$("input[name='OTOnemb']:checked").val()
            var grimace=$("input[name='OTOnefs']:checked").val()
            var appearance=$("input[name='OTOnefus']:checked").val()
            // �����ܷ�
            var total="";
            if(typeof(activity)!="undefined") total=parseInt(activity);
            if(typeof(respiration)!="undefined") total=total==="" ? parseInt(respiration) : total+parseInt(respiration);
            if(typeof(pulse)!="undefined") total=total==="" ? parseInt(pulse) : total+parseInt(pulse);
            if(typeof(grimace)!="undefined") total=total==="" ? parseInt(grimace) : total+parseInt(grimace);
            if(typeof(appearance)!="undefined") total=total==="" ? parseInt(appearance) : total+parseInt(appearance);
            apgarOtherOne.activity=activity
            apgarOtherOne.total=total
            apgarOtherOne.respiration=respiration
            apgarOtherOne.pulse=pulse
            apgarOtherOne.grimace=grimace
            apgarOtherOne.appearance=appearance
            $("#pfoner").val(apgarOtherOne.total);
        }
    });
    // otherTwo
    $HUI.popover('#OtherTwo',{
        title:'',
        content:"",
        width:260,
        backdrop:true,
        height:160,
        url:"#OTTworadioGrop",
        onShow:function(){
            // ��ʼ������
            $("#radioGrop").show();
            $HUI.radio("#OTTwojzl"+apgarOtherTwo.activity).setValue(true);
            $HUI.radio("#OTTwobreath"+apgarOtherTwo.respiration).setValue(true);
            $HUI.radio("#OTTwomb"+apgarOtherTwo.pulse).setValue(true);
            $HUI.radio("#OTTwofs"+apgarOtherTwo.grimace).setValue(true);
            $HUI.radio("#OTTwofus"+apgarOtherTwo.appearance).setValue(true);
        },
        onHide:function(){
            // �ռ�����
            $("#radioGrop").hide();
            var activity=$("input[name='OTTwojzl']:checked").val()
            var respiration=$("input[name='OTTwobreath']:checked").val()
            var pulse=$("input[name='OTTwomb']:checked").val()
            var grimace=$("input[name='OTTwofs']:checked").val()
            var appearance=$("input[name='OTTwofus']:checked").val()
            // �����ܷ�
            var total="";
            if(typeof(activity)!="undefined") total=parseInt(activity);
            if(typeof(respiration)!="undefined") total=total==="" ? parseInt(respiration) : total+parseInt(respiration);
            if(typeof(pulse)!="undefined") total=total==="" ? parseInt(pulse) : total+parseInt(pulse);
            if(typeof(grimace)!="undefined") total=total==="" ? parseInt(grimace) : total+parseInt(grimace);
            if(typeof(appearance)!="undefined") total=total==="" ? parseInt(appearance) : total+parseInt(appearance);
            apgarOtherTwo.activity=activity
            apgarOtherTwo.total=total
            apgarOtherTwo.respiration=respiration
            apgarOtherTwo.pulse=pulse
            apgarOtherTwo.grimace=grimace
            apgarOtherTwo.appearance=appearance
            $("#pftwor").val(apgarOtherTwo.total);
            
        }
    });
    $("#one").val(apgarOne.total);
    $("#one,#five").attr("disabled","disabled");
    $("#five").val(apgarFive.total);
    $("#pfoner").val(apgarOtherOne.total);
    $("#pftwor").val(apgarOtherTwo.total);
    $("#pfonel").numberbox("setValue",apgarMiniuteOtherOne);
    $("#pftwol").numberbox("setValue",apgarMiniuteOtherTwo);
}
function updateName2(){
	setTimeout(function(){
		var name=$("#name").combobox("getText");
		var name2=pinyinUtil.getFirstLetter(name); 
		$("#name2").val(name2);
	})
}
function showUpdateNewBabyDetailWin(rowData){
	$("#newBabyDetailDialog").dialog({
		iconCls:'icon-w-add',
		iconCls:'icon-w-edit',
        buttons:[{
            text:'����',
            handler:function(){
            	save(rowData.pregDelBabyID);
            }
        },{
	        id:"savePrint",
            text:'���沢��ӡ���',
            handler:function(){
            	save(rowData.pregDelBabyID,printIntercept);
            }
        },{
            text:'ȡ��',
            handler:function(){$HUI.dialog('#newBabyDetailDialog').close();}
        }],
        onBeforeClose:function(){
	        dialogOpen=0;
	        initNewBabyDetailWin();
	        changeNewBabyDetailItemStatus();
	    }
  })
  dialogOpen=1;
  $('#newBabyDetailDialog').dialog('open');
  ChangeNewBabyDetailTable_TrStatus();
  initForm(rowData.pregDelBabyID);
}