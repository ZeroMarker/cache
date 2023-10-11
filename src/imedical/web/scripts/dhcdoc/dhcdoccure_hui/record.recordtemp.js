var PageRecordObj={
	SelectKeyword:"U",
	ModalListDataGrid:"",
	NotSaveTempElement:["DCRCureDate","DCRCureEndDate","DCRCureExecDate","ReConfirmUser","DCRCurePOA"], //保存模板时无需保存的元素ID
	TransExpStr:session['LOGON.HOSPID']+ "^" + session['LOGON.LANGID']+ "^" + "doccure.recordtemp.hui.csp"
}
window.onload = function(){ 
    LoadModalListDataGrid(PageRecordObj.SelectKeyword);
    //翻译
    TransLate();
} 
$(function(){
	if(ServerObj.MapID==""){
		$.messager.alert("提示","该治疗申请项目未维护对应的治疗记录模板项目,请联系管理员!");
		return false;	
	}
	//加载患者信息条
	if(typeof InitPatInfoBanner){
		InitPatInfoBanner(ServerObj.EpisodeID); 
	}
	//初始化医嘱表格
	InitVersionMain();
	//缓存加载数据
	CallStorageAllCache();
	//表单初始化
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
	//加载已经保存的申请单数据
	LoaditemReqJsonStr()
	//加载其他信息
	if (ServerObj.BLLoadOther=="Y"){
		LoadOtherInfo(itemReqJsonStr)
	}
    //加载必填项
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

/// 页面兼容配置
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
            	//$.messager.alert("提示","value="+checkedRadioJObj.val()+" , label="+checkedRadioJObj.attr("label"));
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
	//额外信息保存
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
	//打印特殊信息维护
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
            //电子签名
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
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					websys_showModal("close");
				}else{
					$.messager.alert('错误',ErrMsg,"error");
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
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					websys_showModal("close");
				}else if(RetCode=="100"){
					$.messager.alert('警告','保存失败,新增治疗记录,必须选择一条预约记录');
				}else if(RetCode=="101"){
					$.messager.alert('警告','保存失败,保存失败,一个预约仅限添加一条治疗记录');
				}else if(RetCode=="102"){
					$.messager.alert('警告','保存失败,预约记录没有对应的执行记录,不能做治疗');
				}else if(RetCode=="103"){
					$.messager.alert('警告','保存失败,已取消预约的不能够添加治疗记录');
				}else if(RetCode=="104"){
					$.messager.alert('警告','保存失败,治疗开始时间不能晚于治疗结束时间');
				}else if(RetCode=="-303"){
					$.messager.alert('警告','保存失败,该预约记录已被执行!');
				}else{
					errmsg='保存失败'+",错误代码:"+RetCode;
					$.messager.alert('错误',errmsg);
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
					$.messager.alert("提示",OneCheckStr.split(String.fromCharCode(1))[1]+"不能为空!","warning");
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
					$.messager.alert("提示",OneCheckStr.split(String.fromCharCode(1))[1]+"长度过长,限制长度:"+OneLength+",请重新填写!");
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
				//界面元素不可用的不赋值
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
				    	_$label[labk].innerHTML=$g(domName); //基础平台
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
	        {text:'个人模板',id:'U'},
	        {text:'科室模板',id:'L'},
	        {text:'通用模板',id:'C',selected:true}
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
		page:1,    //可选项，页码，默认1
		rows:99999    //可选项，获取多少条数据，默认50
	},function(GridData){
		$("#ModalListDataGrid").datagrid('loadData', GridData);
	});
}

function SaveModel(){
	$code='<div id="win_modal">'
	$code=$code+'<div style="margin-top:10px;text-align:center">'
	$code=$code+'<input type="text" class="hisui-validatebox" placeholder="请填写模板标题名称" id="ModelTitle" style="width:290px"/>'
	$code=$code+'</div>'
	$code=$code+'<div style="margin-top:10px;text-align:center;">'
	$code=$code+'<a href="#" class="hisui-linkbutton btn-lightgreen" onclick="SaveLocModel()">科室模板</a>'
	$code=$code+'<a href="#" class="hisui-linkbutton m-left-10" onclick="SaveUserModel()">个人模板</a>'
	$code=$code+'<a href="#" class="hisui-linkbutton m-left-10" onclick="SaveComModel()">通用模板</a>'
	$code=$code+'</div>'
	$code=$code+'</div>'
	com_Util.createModalDialog("SaveModelDiag","选择模板", 350, 140,"icon-w-save","",$code,"");  
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
		$.messager.alert("提示","请填写模板标题名称","warning",function(){
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
			$.messager.popover({msg: "保存成功!",type:'success'});
			com_Util.destroyDialog("SaveModelDiag");
			$("#ModalType").keywords("select",Type)
		}else{
			$.messager.alert("提示","保存失败!错误代码:"+ret,"warning");	
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
			{field:'ArcimDesc',title:'医嘱名称',width:100,align:'left', resizable: true},
			{field:'CRTTitle',title:'标题',width:500,align:'left', resizable: true},
			{field:'CRTSaveUser',title:'保存用户',width:100,align:'left', resizable: true},
			{field:'CRTSavePointer',title:'CRTSavePointer',width:20,align:'left', hidden: true},
			{field:'CRTSaveUserDr',title:'CRTSaveUserDr',width:20,align:'left', hidden: true},
			{field:'CRTRowID',title:'CRTRowID',width:20,align:'left', hidden: true}, 
			{field:'CRTExpJsonStr',title:'CRTExpJsonStr',width:120,align:'left', hidden: true}
		]],
		toolbar:[{
	        text: '引用',
	        iconCls: 'icon-copy',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
					SetValueByModal(row);
		        }else{
			        $.messager.alert("警告","请选择一行需要引用的记录.","warning")
			    }
	        }
	    },{
	        text: '删除',
	        id: "delModal",
	        iconCls: 'icon-remove',
	        handler: function() {
		        var row=PageRecordObj.ModalListDataGrid.datagrid("getSelected");
		        if(row){
			        var CRTRowID=row.CRTRowID;
			        var CRTSaveUserDr=row.CRTSaveUserDr;
			   		if(CRTSaveUserDr!=_PageCureObj.LogUserID){
				   		$.messager.alert("警告","非本人保存模板无法删除.","warning");
						return false;	
				   	}
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.CureItemSet",
						MethodName:"DelItemSetRecordTemp",
						DDCRTRowid:	CRTRowID
					},function(ret){
						if(ret==0){
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							LoadModalListDataGrid();
						}else{
							$.messager.alert("警告","删除失败,错误代码:"+ret,"warning");
							return false;		
						}
					})	
		        }else{
			        $.messager.alert("警告","请选择一行需要删除的记录","warning")
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