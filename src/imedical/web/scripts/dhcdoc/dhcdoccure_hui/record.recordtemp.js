var PageRecordObj={
	SelectKeyword:"U",
	ModalListDataGrid:"",
	NotSaveTempElement:["DCRCureDate","DCRCureEndDate","DCRCureExecDate","ReConfirmUser","DCRCurePOA"], //����ģ��ʱ���豣���Ԫ��ID
	TransExpStr:session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + "doccure.recordtemp.hui.csp"
}
window.onload = function(){ 
    LoadModalListDataGrid(PageRecordObj.SelectKeyword);
    //����
    TransLate();
} 
$(function(){
	if(ServerObj.MapID==""){
		$.messager.alert("��ʾ","������������Ŀδά����Ӧ�����Ƽ�¼ģ����Ŀ,����ϵ����Ա!");
		return false;	
	}
	//���ػ�����Ϣ��
	if(typeof InitPatInfoBanner){
		InitPatInfoBanner(ServerObj.EpisodeID); 
	}
	//��ʼ��ҽ�����
	InitVersionMain();
	//�����������
	CallStorageAllCache();
	//����ʼ��
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval("("+oneBLIDArr[0]+")") 
				if(typeof(Obj.Init)=="function"){
					Obj.Init()
				}
			}
		}
	}
	if (ServerObj.BLInit=="Y"){
		if(typeof(Init)=="function"){
			Init()
		}
	}
	//�����Ѿ���������뵥����
	LoaditemReqJsonStr()
	//����������Ϣ
	if (ServerObj.BLLoadOther=="Y"){
		LoadOtherInfo(itemReqJsonStr)
	}
    //���ر�����
    addclsRequired();
    InitModal();
    InitEvent();
})

function InitModal(){
	PageRecordObj.ModalListDataGrid=InitModalListDataGrid();
    InitKeyWords();
}

function InitEvent(){
    $('#btnSave').click(Save);
	$('#SaveModel').click(SaveModel);	
}

/// ҳ���������
function InitVersionMain(){

}

function CallStorageAllCache(){
	if (ServerObj.CacheMapRowIDStr!=""){
		storageAllCache.storage(ServerObj.CacheMapRowIDStr,ServerObj.CacheMapIDStr)
	}
}

function addclsRequired(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",ServerObj.MapID);
	var itmmastid=$("#TesItemID").val();
	if (typeof itmmastid!='undefined' && itmmastid!="") {
		var HideAry=ServerObj.MapStr.split("||");
		for (var i=0; i< HideAry.length; i++){
			var AcquireStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireArcItem",ServerObj.MapID,HideAry[i],itmmastid);
			if (AcquireStr!="") {
				if (CheckStr=="") CheckStr=AcquireStr;
				else CheckStr=CheckStr+"^"+AcquireStr;
			}
		}
	}
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			if ($("#"+ID).length > 0){
				$("label[for="+ID+"]").addClass("clsRequired");
			}
		}
	}
}

function GetSaveJsonStr(SaveAsTemp){
	if(SaveAsTemp){
		var Savestr=tkMakeServerCall("DHCDoc.DHCDocCure.Assessment","GetCacheItem",ServerObj.MapID);
	}else{
		var Savestr=tkMakeServerCall("web.DHCDocAPPBL","GetSaveItem",ServerObj.MapID);
	}
	var SaveAry=Savestr.split("^")
	var JsonAry = new Array();
	for (var i=0;i<SaveAry.length;i++) {
		var ID=SaveAry[i];
		if(SaveAsTemp && PageRecordObj.NotSaveTempElement.indexOf(ID)>=0){
			continue	
		}
		if ($("#"+ID).length > 0){
			if ($("#"+ID).hasClass('combobox-f')){
				var opt=$("#"+ID).combobox("options");
				if(opt.multiple){
					var val = $HUI.combobox("#"+ID).getValues(); 
					val=val.join(String.fromCharCode(1));
					var desc = $HUI.combobox("#"+ID).getText(); 
				}else{
					var val = $HUI.combobox("#"+ID).getValue(); 
					var desc = $HUI.combobox("#"+ID).getText(); 
				}
			}else if ($("#"+ID).hasClass('hisui-checkbox')){
				var  val=$("#"+ID).prop("checked");
				var  desc = $("label[for="+ID+"]").innerHTML;				
			}else if ($("#"+ID).hasClass('hisui-datetimebox')){
				var val = $HUI.datetimebox("#"+ID).getValue();
				var desc = 	$HUI.datetimebox("#"+ID).getValue();	
			}else if ($("#"+ID).hasClass('hisui-datebox')){
				var val = $HUI.datebox("#"+ID).getValue(); 
				var desc = $HUI.datebox("#"+ID).getValue(); 		
			}else if($("#"+ID).hasClass('combogrid-f')){
				var val = $HUI.combogrid("#"+ID).getValue(); 
				var desc = $HUI.combogrid("#"+ID).getText(); 
			}else if ($("#"+ID).hasClass('hisui-timespinner')){
				var val = $HUI.timespinner("#"+ID).getValue(); 		
			}else if ($("#"+ID).hasClass('hisui-numberbox')){
				var val = $HUI.numberbox("#"+ID).getValue(); 		
			}else if($("#"+ID).hasClass('hisui-radio')){
				//{"ID":"CBAssContraindications_No","Val":"CBAssContraindications_Yes","Class":"radio","Desc":"CBAssContraindications"}
				var RadioNameArr=ID.split("_");
				var RadioID="";
				for(var loop=0;loop<RadioNameArr.length-1;loop++){
					if(RadioID==""){
						RadioID=RadioNameArr[loop]	
					}else{
						RadioID=RadioID+"_"+RadioNameArr[loop];
					}
				}
				if(RadioID==""){RadioID=ID}
				var checkedRadioJObj = $("input[name='"+RadioID+"']:checked");
            	//$.messager.alert("��ʾ","value="+checkedRadioJObj.val()+" , label="+checkedRadioJObj.attr("label"));
            	var val=checkedRadioJObj.val(); //radio_check
            	var desc=RadioID;
			}else{
				var val=$("#"+ID).val()
				var desc = $("#"+ID).val() 
			}
			var className = getComponentType(ID)
			JsonAry[JsonAry.length]={
				ID:ID,
				Val:val,
				Class:className,
				Desc:desc
			};
		}
	}
	//������Ϣ����
	var otherinfo=""
	var rtnObj = {}
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval("("+oneBLIDArr[0]+")") 
				if(typeof(Obj.OtherInfo)=="function"){
					var BLObj=Obj.OtherInfo()
					if (BLObj!="") {$.extend(rtnObj, BLObj);}
				}
			}
		}
	}
	if (ServerObj.BLSaveOther=="Y"){
		var SaveObj=SaveOtherInfo()
		if (SaveObj!="") {$.extend(rtnObj, SaveObj);}
	}
	otherinfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"OtherInfo",
		Val:otherinfo,
		Class:"Data"
	};
	//��ӡ������Ϣά��
	var PrintInfo=""
	var rtnObj = {}
	if (ServerObj.BLIDStr!=""){
		var BLIDStrArry=ServerObj.BLIDStr.split("^")
		for (var i = 0; i < BLIDStrArry.length; i++) {
			var oneBLIDStr=BLIDStrArry[i];
			var oneBLIDArr=oneBLIDStr.split(String.fromCharCode(1));
			if(oneBLIDArr[1]==1){
				var Obj=eval(oneBLIDArr[0]) 
				if(typeof(Obj.PrintInfo)=="function"){
					var BLObj=Obj.PrintInfo()
					if (BLObj!="") {$.extend(rtnObj, BLObj);}
				}
			}
		}
	}
	PrintInfo=JSON.stringify(rtnObj);
	JsonAry[JsonAry.length]={
		ID:"PrintInfo",
		Val:PrintInfo,
		Class:"Data"
	};
	//var JsonStr=JSON.stringify(JsonAry);	
	return JsonAry;
}

function Save(){
    var UpdateObj={}
    if(typeof CASignObj == 'undefined'){
        CASignObj=window.parent.CASignObj;
    }
    new Promise(function(resolve,rejected){
        if (!CheckforUpdate()){
            return false;
        }else{
            resolve();
        }
    }).then(function (){
        return new Promise(function(resolve,rejected){
            //����ǩ��
            CASignObj.CASignLogin(resolve,"CureAss",false)
        }).then(function(CAObj){
            return new Promise(function(resolve,rejected){
                if (CAObj == false) {
                    return websys_cancel();
                } else{
                    $.extend(UpdateObj, CAObj);
                    resolve(true);
                }
            })
        })  
    }).then(function(){
        var JsonAry=GetSaveJsonStr();
        var DCRRowId=ServerObj.DCRRowId;
		var source=ServerObj.source;
		var RowIdStr=ServerObj.DCAARowIdStr;
		if(RowIdStr==""){RowIdStr=ServerObj.OEORERowIDS;}
	    if((DCRRowId=="")&&(RowIdStr=="")){
		    return false;
	    }
	    
		if(source=="")source="R";
		var ParaObj={};		
		ParaObj.CureExpJsonStr=JsonAry;
		ParaObj.UserDR=session['LOGON.USERID'];
		ParaObj.LogonLocDr=session['LOGON.CTLOCID'];
		ParaObj.HospId=session['LOGON.HOSPID'];
		ParaObj.DCRRowId=DCRRowId;
		ParaObj.QueId=ServerObj.QueId;
		ParaObj.DCRCureMapID=ServerObj.MapID;
		if(RowIdStr!=""){
			ParaObj.DCAARowId="";
			ParaObj.OEORERowID="";
			var ParaJson=JSON.stringify(ParaObj);
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"SaveCureRecordBatch",
				ParaJson:ParaJson,
				RowIdStr:RowIdStr,
				UserDR:session['LOGON.USERID'],
				Source:source,
				TransExpStr:PageRecordObj.TransExpStr
			},function(value){
				var ErrMsg=value.split(String.fromCharCode(1))[0];
				var SuccIDStr=value.split(String.fromCharCode(1))[1];
				if(SuccIDStr!=""){
					if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, SuccIDStr, "CureRecord");
				}
				if(ErrMsg==""){
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					websys_showModal("close");
				}else{
					$.messager.alert('����',ErrMsg,"error");
				}
			})
		}else{
			ParaObj.DCAARowId="";
			ParaObj.OEORERowID="";
			var ParaJson=JSON.stringify(ParaObj);
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Record",
				MethodName:"SaveCureRecord",
				ParaJson:ParaJson
			},function(value){
				var RetDCRRowId="";
				if(value.indexOf("^")>0){
					var RetCode=value.split("^")[0];
					RetDCRRowId=value.split("^")[1];		
				}else{
					var RetCode=value;	
				}
				if(RetCode==0){
					if( RetDCRRowId!=""){
						if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, RetDCRRowId, "CureRecord");
					}
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
					websys_showModal("close");
				}else if(RetCode=="100"){
					$.messager.alert('����','����ʧ��,�������Ƽ�¼,����ѡ��һ��ԤԼ��¼');
				}else if(RetCode=="101"){
					$.messager.alert('����','����ʧ��,����ʧ��,һ��ԤԼ�������һ�����Ƽ�¼');
				}else if(RetCode=="102"){
					$.messager.alert('����','����ʧ��,ԤԼ��¼û�ж�Ӧ��ִ�м�¼,����������');
				}else if(RetCode=="103"){
					$.messager.alert('����','����ʧ��,��ȡ��ԤԼ�Ĳ��ܹ�������Ƽ�¼');
				}else if(RetCode=="104"){
					$.messager.alert('����','����ʧ��,���ƿ�ʼʱ�䲻���������ƽ���ʱ��');
				}else if(RetCode=="-303"){
					$.messager.alert('����','����ʧ��,��ԤԼ��¼�ѱ�ִ��!');
				}else{
					errmsg='����ʧ��'+",�������:"+RetCode;
					$.messager.alert('����',errmsg);
				}
			})
		}
    })
}

function CheckforUpdate(){
	var CheckStr=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireItem",ServerObj.MapID);
	
	if (CheckStr!=""){
		var CheckAry=CheckStr.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			if ($("#"+ID).length > 0){
				if ($("#"+ID).hasClass('combobox-f')){
					var val = $HUI.combobox("#"+ID).getValue(); 
				}else if ($("#"+ID).hasClass('hisui-checkbox')){
					var  val=$("#"+ID).prop("checked");
				}else if ($("#"+ID).hasClass('hisui-timespinner')){
					var val = $HUI.timespinner("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-numberbox')){
					var val = $HUI.numberbox("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-datetimebox')){
					var val = $HUI.datetimebox("#"+ID).getValue(); 		
				}else if ($("#"+ID).hasClass('hisui-datebox')){
					var val = $HUI.datebox("#"+ID).getValue();
						//$HUI.datebox("#"+ID).setValue(Val);  		
				}else{
					var val=$("#"+ID).val()
					}
				if (val==""){
					$.messager.alert("��ʾ",OneCheckStr.split(String.fromCharCode(1))[1]+"����Ϊ��!","warning");
					return false;
				}
			}
		}
	}
	var CheckStrLenght=tkMakeServerCall("web.DHCDocAPPBL","GetAcquireLength",ServerObj.MapID);
	if (CheckStrLenght!=""){
		var CheckAry=CheckStrLenght.split("^")
		for (var i=0;i<CheckAry.length;i++) {
			var OneCheckStr=CheckAry[i]
			var ID=OneCheckStr.split(String.fromCharCode(1))[0]
			var OneLength=OneCheckStr.split(String.fromCharCode(1))[2]
			if ($("#"+ID).length > 0){
				var val=$("#"+ID).val()
				var vallenght=val.length
				if (vallenght>OneLength){
					$.messager.alert("��ʾ",OneCheckStr.split(String.fromCharCode(1))[1]+"���ȹ���,���Ƴ���:"+OneLength+",��������д!");
					return false;
					}
				}
			}
		}
	if (typeof CheckSaveInfo === "function") {
		var CheckSave=CheckSaveInfo()
		if (CheckSave==false){
			return false;
		}
	}
	return true;
}

function getComponentType(id){
	var className = $("#"+id).attr("class")||"";
	
	if (className == "") {
		return "text";
	}else if ((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0)) {
		return "lookup";
	} else if( className.indexOf("combobox-f") >=0 ) {
		return "combobox";
	} else if((className.indexOf("hisui-datebox")>=0)||(className.indexOf("datebox-f")>=0)) {
		return "datebox";
	} else if (className.indexOf("hisui-linkbutton")>=0) {
		return "button";
	} else if (className.indexOf("hisui-radio")>=0) {
		return "radio";
	} else if (className.indexOf("hisui-checkbox")>=0) {
		return "checkbox";
	} else if (className.indexOf("hisui-timespinner")>=0) {
		return "timespinner";
	} else if (className.indexOf("hisui-numberbox")>=0) {
		return "numberbox";
	} else {
		return "text";
	}
}

function LoaditemReqJsonStr(flag){
	if (itemReqJsonStr!=""){
		for (var i = 0; i < itemReqJsonStr.length; i++) {
			var OneReqJson=itemReqJsonStr[i]
			var ID=OneReqJson.ID
			var Val=OneReqJson.Val
			var Desc=OneReqJson.Desc
			if ($("#"+ID).length > 0){
				var tobj=$("#"+ID)[0];
				//����Ԫ�ز����õĲ���ֵ
				if(flag=="Y" && tobj.disabled){
					continue;	
				}
				setEleValue(ID,Val,Desc);
			}
        }
	}
}

function setEleValue(ID,Val,Desc){
	if ($("#"+ID).length > 0){
		if ($("#"+ID).hasClass('combobox-f')){
			var opt=$("#"+ID).combobox("options");
			if(opt.multiple){
				$HUI.combobox("#"+ID).setValues(Val.split(String.fromCharCode(1))); 
				$HUI.combobox("#"+ID).setText(Desc);
			}else{
				$HUI.combobox("#"+ID).setValue(Val); 
				$HUI.combobox("#"+ID).setText(Desc);
			}
		}else if ($("#"+ID).hasClass('hisui-checkbox')){
			//$("#"+ID).attr("checked",Val); 
			$HUI.checkbox("#"+ID).setValue(Val); 
		}else if ($("#"+ID).hasClass('hisui-datetimebox')){
			$HUI.datetimebox("#"+ID).setValue(Val); 
		}else if ($("#"+ID).hasClass('hisui-datebox')){
			//var val = $HUI.datebox("#"+ID).getValue();
			$HUI.datebox("#"+ID).setValue(Val);  		
		}else if ($("#"+ID).hasClass('hisui-timespinner')){
			$HUI.timespinner("#"+ID).setValue(Val); 		
		}else if ($("#"+ID).hasClass('hisui-numberbox')){
			$HUI.numberbox("#"+ID).setValue(Val); 		
		}else if ($("#"+ID).hasClass('hisui-radio')){
			if(typeof Val != 'undefined'){
				$HUI.radio("#"+Val).setValue(true);	
			}else{
				//var $browsers = $("input[name="+Desc+"]");	
				//$browsers.removeAttr("checked");
				$HUI.radio("input[name="+Desc+"]").setValue(false);	
			}
		}else{
			$("#"+ID).val(Val)
		}
	}
}

function TransLate(){
	var MapIDStrArr=ServerObj.BLIDStr.split("^")
	for (var i = 0; i < MapIDStrArr.length; i++) {
		var OneMapIDStr=MapIDStrArr[i];
		var OneMapID=OneMapIDStr.split(String.fromCharCode(1))[0];
		var rtnObj = {}
		var arrayObj = new Array(
	      new Array(".textbox"),
	      new Array(".hisui-checkbox"),
		  new Array(".hisui-datetimebox"),
		  new Array(".hisui-radio")
		);
		for( var j=0;j<arrayObj.length;j++) {
		var domSelector=arrayObj[j][0]
		var $nodes=$("#"+OneMapID).find(domSelector)
		for (var ijj=0; ijj< $nodes.length; ijj++){
				var domId = $nodes[ijj]['id']||"";
				if (domId == "") {
					continue;
				}
				var componentType = "" //getComponentType(domId)
				var isJump = ""  //supportJump(componentType);
				var domName = "";
				var _$label = $("label[for="+domId+"]");
				if (_$label.length > 0){
					for(var labk=0; labk< _$label.length; labk++){
				   		domName = _$label[labk].innerHTML;
				    	_$label[labk].innerHTML=$g(domName); //����ƽ̨
					}
				}
			}
		}
	}
}

function InitKeyWords(){
	$("#ModalType").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:[
	        {text:'����ģ��',id:'U'},
	        {text:'����ģ��',id:'L'},
	        {text:'ͨ��ģ��',id:'C',selected:true}
	    ],
	    onClick:function(v){
		    $("#delModal").linkbutton("enable");
		    LoadModalListDataGrid(v.id)
		},
	    onSelect:function(v){}
	});
	$("#ModalType").keywords("select",PageRecordObj.SelectKeyword)
}

function GetKeyWord(){
	var KeyWord="";
	var keyobj=$("#ModalType").keywords("getSelected");
	if(keyobj.length>0){
		KeyWord=keyobj[0].id;	
	}
	return KeyWord;
}
function LoadModalListDataGrid(Type)
{
	if((Type=="")||(typeof(Type)=="undefined")){
		Type=GetKeyWord();	
	}
	$("#ModalListDataGrid").datagrid("unselectAll");
	if(Type=="C"){
		var Pointer="";
	}else{
		var Pointer=(Type=="L"?_PageCureObj.LogCTLocID:_PageCureObj.LogUserID);	
	}
	$cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		QueryName:"FindCRT",
		DDCISRowid:ServerObj.DDCISRowidStr,
		Query:"",
		SaveAs:Type,
		ResultSetType:"array",
		Pointer:Pointer,
		MapID:ServerObj.MapID,
		page:1,    //��ѡ�ҳ�룬Ĭ��1
		rows:99999    //��ѡ���ȡ���������ݣ�Ĭ��50
	},function(GridData){
		$("#ModalListDataGrid").datagrid('loadData', GridData);
	});
}

function SaveModel(){
	$code='<div id="win_modal">'
	$code=$code+'<div style="margin-top:10px;text-align:center">'
	$code=$code+'<input type="text" class="hisui-validatebox" placeholder="����дģ���������" id="ModelTitle" style="width:290px"/>'
	$code=$code+'</div>'
	$code=$code+'<div style="margin-top:10px;text-align:center;">'
	$code=$code+'<a href="#" class="hisui-linkbutton btn-lightgreen" onclick="SaveLocModel()">����ģ��</a>'
	$code=$code+'<a href="#" class="hisui-linkbutton m-left-10" onclick="SaveUserModel()">����ģ��</a>'
	$code=$code+'<a href="#" class="hisui-linkbutton m-left-10" onclick="SaveComModel()">ͨ��ģ��</a>'
	$code=$code+'</div>'
	$code=$code+'</div>'
	com_Util.createModalDialog("SaveModelDiag","ѡ��ģ��", 350, 140,"icon-w-save","",$code,"");  
}
function SaveComModel(){
	SaveSelectModel("C");	
}
function SaveLocModel(){
	SaveSelectModel("L");
}
function SaveUserModel(){
	SaveSelectModel("U");
}
function SaveSelectModel(Type)
{
	var JsonAry=GetSaveJsonStr(true);
	var CRTTitle=$("#ModelTitle").val();
	if(CRTTitle==""){
		$.messager.alert("��ʾ","����дģ���������","warning",function(){
			$("#ModelTitle").focus();
		});	
		return false;
	}
	var JsonStr=JSON.stringify(JsonAry);
	var SaveAs=(Type=="L"?_PageCureObj.LogCTLocID:_PageCureObj.LogUserID);
	var DCRTExpStr=Type+"^"+SaveAs+"^"+_PageCureObj.LogUserID+"^"+JsonStr+"^"+ServerObj.MapID;
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.CureItemSet",
		MethodName:"SaveRecordTemp",
		RowidStr:ServerObj.DDCISRowidStr,
		CRTTitle:CRTTitle,
		CRTDetail:"",
		CRTType:"",
		CRTResponse:"",
		CRTEffect:"",
		CRTExpStr:DCRTExpStr
	},function(ret){
		if(ret==0){
			$.messager.popover({msg: "����ɹ�!",type:'success'});
			com_Util.destroyDialog("SaveModelDiag");
			$("#ModalType").keywords("select",Type)
		}else{
			$.messager.alert("��ʾ","����ʧ��!�������:"+ret,"warning");	
		}
	})
	
}
function InitModalListDataGrid(){
	var ModalListDataGrid=$('#ModalListDataGrid').datagrid({
		//view:scrollview,
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		fitColumns : false,
		rownumbers:true,
		singleSelect:true,
		autoRowHeight:false,
		pagination:false,
		pageSize:99999,
		idField:"CRTRowID",
		columns :[[ 
			{field:'ArcimDesc',title:'ҽ������',width:100,align:'left', resizable: true},
			{field:'CRTTitle',title:'����',width:500,align:'left', resizable: true},
			{field:'CRTSaveUser',title:'�����û�',width:100,align:'left', resizable: true},
			{field:'CRTSavePointer',title:'CRTSavePointer',width:20,align:'left', hidden: true},
			{field:'CRTSaveUserDr',title:'CRTSaveUserDr',width:20,align:'left', hidden: true},
			{field:'CRTRowID',title:'CRTRowID',width:20,align:'left', hidden: true}, 
			{field:'CRTExpJsonStr',title:'CRTExpJsonStr',width:120,align:'left', hidden: true}
		]],
		toolbar:[{
	        text: '����',
	        iconCls: 'icon-copy',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
					SetValueByModal(row);
		        }else{
			        $.messager.alert("����","��ѡ��һ����Ҫ���õļ�¼.","warning")
			    }
	        }
	    },{
	        text: 'ɾ��',
	        id: "delModal",
	        iconCls: 'icon-remove',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
			        var CRTRowID=row.CRTRowID;
			        var CRTSaveUserDr=row.CRTSaveUserDr;
			   		if(CRTSaveUserDr!=_PageCureObj.LogUserID){
				   		$.messager.alert("����","�Ǳ��˱���ģ���޷�ɾ��.","warning");
						return false;	
				   	}
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.CureItemSet",
						MethodName:"DelItemSetRecordTemp",
						DDCRTRowid:	CRTRowID
					},function(ret){
						if(ret==0){
							$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
							LoadModalListDataGrid();
						}else{
							$.messager.alert("����","ɾ��ʧ��,�������:"+ret,"warning");
							return false;		
						}
					})	
		        }else{
			        $.messager.alert("����","��ѡ��һ����Ҫɾ���ļ�¼","warning")
			    }
	        }
	    }
		],
		onClickRow:function(rowIndex, rowData){
			/*var KeyWord=GetKeyWord();	
			if (KeyWord=="C"){
				$("#delModal").linkbutton("disable");
			}else{
				$("#delModal").linkbutton("enable");
			}*/
		},
		onDblClickRow:function(rowIndex, rowData){
			SetValueByModal(rowData);
		}	
	});
	return ModalListDataGrid;
}

function SetValueByModal(row){
	var JsonData=row.CRTExpJsonStr;
	itemReqJsonStr=JSON.parse(JsonData); 
	LoaditemReqJsonStr("Y");
}