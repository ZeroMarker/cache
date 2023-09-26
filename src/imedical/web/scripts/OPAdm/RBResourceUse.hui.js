var PageLogicObj={
	m_SelGHUserID:""
};
$(document).ready(function(){
	Init();
	InitEvent();
	
});
function Init(){
	//InitGHUser();
	var hospComp = GenHospComp("DHCUserGroup");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		$("#List_UDoc").empty();
		$("#List_UDept").empty();
		$("#List_AllDept").empty();
		$("#GHUser").val("")
		PageLogicObj.m_SelGHUserID="";
		//$HUI.lookup("#GHUser").hidePanel();
	}
	InitGHUserLook();
}

function InitEvent(){
	$('#BtnUpdate').click(UpdateClickHandle)
	$('#BtnAdd').click(AddClickHandle)
	$('#List_AllDept').dblclick(AllDeptDblClickHandle);
	$('#List_UDept').dblclick(UDeptDblClickHandle);
	$('#List_UDept').click(UDeptClickHandle);
	$('#LocNameDesc').keydown(LocNameDesc_keydown);
	$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle(){
	if(ServerObj.Type=="NUR"){
		$HUI.panel("#pan_center").setTitle("护士加号权限");	
	}
	var centerwidth=$("#pan_center").width();
	var setwidth=centerwidth-50;
	$("#div_popover").width(setwidth)
}
//排班人员放大镜查询
function InitGHUserLook(){
	 $("#GHUser").lookup({
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'SSUSR_RowId',
        textField:'SSUSR_Name',
        columns:[[  
            {field:'SSUSR_Name',title:'姓名',width:150,sortable:true},
			{field:'SSUSR_Initials',title:'工号',width:100,sortable:true},
			{field:'SSUSR_RowId',title:'ID',width:80,sortable:true,hidden:true},
        ]],
        pagination:true,
        panelWidth:420,
        panelHeight:260,
        isCombo:true,
        minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCUserGroup',QueryName: 'Finduse1'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			var HospID=$HUI.combogrid('#_HospList').getValue();
			param = $.extend(param,{'Desc':desc,'HOSPID':HospID});
			PageLogicObj.m_SelGHUserID="";
	    },onSelect:function(ind,item){
            var Desc=item['SSUSR_Name'];
			var ID=item['SSUSR_RowId'];
			PageLogicObj.m_SelGHUserID=ID;
			$HUI.lookup("#GHUser").hidePanel();
			InitDeptList("List_AllDept","ALL");
			InitDeptList("List_UDept","USE");
			$("#List_UDoc").empty();
		}
    });
}
//排班人员下拉选择
function InitGHUser(){
	$.cm({
		ClassName:"web.DHCUserGroup",
		QueryName:"Finduse1",
		'Desc':"",
		dataType:"json",
		rows:99999
	},function(Data){
		$HUI.combobox("#GHUser", {
			valueField: 'SSUSR_RowId',
			textField: 'SSUSR_Name', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return ((row["SSUSR_Name"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["SSUSR_Initials"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
			},onSelect:function(record){
				InitDeptList("List_AllDept","ALL");
				InitDeptList("List_UDept","USE");
				$("#List_UDoc").empty();
			},onHidePanel:function(){
				var UserID=$HUI.combobox("#GHUser").getValue();
				if((UserID!="")&&(typeof(UserID)!="undefined")){
					InitDeptList("List_AllDept","ALL");
					InitDeptList("List_UDept","USE");
					$("#List_UDoc").empty();	
				}
			}
		});
	});	
}

function InitDeptList(ComboName,Type,Desc){
	//var UserID=$HUI.combobox("#GHUser").getValue();
	var UserID=PageLogicObj.m_SelGHUserID;
	if (UserID==""){
		$.messager.alert("提示","请先选择一个排班员","info");
		return false;
	}
	if(typeof(Desc)=="undefined")Desc="";

	$("#"+ComboName).empty();
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if(UserID!=""){
		$.cm({
			ClassName:"web.DHCUserGroup",
			MethodName:"GetLocInfo",
			User:UserID,
			Desc:Desc,
			Type:Type,
			license:ServerObj.Type,
			loghosp:HospID,
			dataType:"text",	
		},function(objScope){
			if(objScope=="")return;
			var objScopeArr=objScope.split(String.fromCharCode(2));
			var vlist = ""; 
			var selectlist="";
			for(var i=0;i<objScopeArr.length;i++){
				var oneLoc=	objScopeArr[i];
				var oneLocArr=oneLoc.split(String.fromCharCode(1))
				var LocRowID=oneLocArr[1];
				var LocDesc=oneLocArr[0];
				vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			}
			$("#"+ComboName).append(vlist); 
		})
	}
}

function LocNameDesc_keydown(e){
	var key=websys_getKey(e);
	if (key==13){
		var Desc=$('#LocNameDesc').val();
		InitDeptList("List_AllDept","ALL",Desc);
	}
}

function AllDeptDblClickHandle(){
	var tmp=$("#List_AllDept option:selected").val();
	if(typeof(tmp)=="undefined")return;
	AddClickHandle();
}

function AddClickHandle() {
	//var UserID=$HUI.combobox("#GHUser").getValue();
	var UserID=PageLogicObj.m_SelGHUserID;
	if (UserID==""){
		$.messager.alert("提示","请先选择一个排班员","info");
		return false;
	}
	var obj=document.getElementById('List_AllDept');
	var length=obj.length;
	for(i=length-1;i>=0;i--){
		if (obj.options[i].selected){
			var value=obj.options[i].value;
			var text=obj.options[i].text;
			obj.remove(i);
			AddList("List_UDept",text,value);
		}
	}
}
function AddList(ElementName,value,text,Selected){
	var obj=document.getElementById(ElementName);
	var length=obj.length;
	obj.options[length] = new Option(value,text);
	if (Selected==1) obj.options[length].selected=true;
}

function Bdel_click() {
	
 	//var UserID=$HUI.combobox("#GHUser").getValue();
 	var UserID=PageLogicObj.m_SelGHUserID;
	if (UserID==""){
		$.messager.alert("提示","请先选择一个排班员","info");
		return false;
	}
	var obj=document.getElementById('List_UDept');
	var length=obj.length;
	
	for(i=length-1;i>=0;i--){
		if (obj.options[i].selected){
			//$.messager.confirm("提示","确实要删除选中的科室吗?",function(r,UserID,value){
				//if(r){
					if (!(dhcsys_confirm("确定要删除选中的科室吗?"))) {  return false; }
					var value=obj.options[i].value;
					var text=obj.options[i].text;
					var ret=$.cm({
						ClassName:"web.DHCUserGroup",
						MethodName:"delu",
						itmjs:"",
						itmjsex:"",
						name:UserID,
						group:value,
						type:ServerObj.Type,
						dataType:"text",
					},false)
					if (ret!="0"){
						$.messager.alert("提示","删除原有数据错误"+ret,"error");
						return false;
					}
					obj.remove(i);
					AddList("List_AllDept",text,value);	
					$("#List_UDoc").empty();
				//}	
			//})
		}
	}
}

function UDeptClickHandle(){
	var LocID=$("#List_UDept option:selected").val();
	if(typeof(LocID)=="undefined")return;	
	//var UserID=$HUI.combobox("#GHUser").getValue();
	var UserID=PageLogicObj.m_SelGHUserID;
	if (UserID==""){
		$.messager.alert("提示","请先选择一个排班员","info");
		return false;
	}
	if(typeof(Desc)=="undefined")Desc="";
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$("#List_UDoc").empty();
	if(UserID!=""){
		var objScope=$.cm({
			ClassName:"web.DHCUserGroup",
			MethodName:"GetDocInfo",
			UserID:UserID,
			LocID:LocID,
			QType:"",
			Type:ServerObj.Type,
			HospID:HospID,
			dataType:"text",	
		},false)
	}
	if(objScope=="")return;
	var objScopeArr=objScope.split(String.fromCharCode(2));
	var vlist = ""; 
	var selectlist="";
	for(var i=0;i<objScopeArr.length;i++){
		var oneLoc=	objScopeArr[i];
		var oneLocArr=oneLoc.split(String.fromCharCode(1))
		var LocRowID=oneLocArr[1];
		var LocDesc=oneLocArr[0];
		var SelFalg=oneLocArr[2];
		if(SelFalg==1){
			vlist += "<option value=" + LocRowID + " selected>" + LocDesc + "</option>"; 
		}else{
			vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
		}
	}
	$("#List_UDoc").append(vlist); 
	
}

function UDeptDblClickHandle(){
	var tmp=$("#List_UDept option:selected").val();
	if(typeof(tmp)=="undefined")return;
	Bdel_click();
	UDeptClickHandle();
}

function UpdateClickHandle(){
	//var tmp=$("#List_UDept option:selected").val();
	var tmp=document.getElementById('List_UDept');
	if(tmp.selectedIndex<0){
		$.messager.alert("提示","请先选择一个排班科室","info");
		return false;	
	}
	var selectObj=tmp.options[tmp.selectedIndex];
	if(selectObj){
		var SelDept=selectObj.value
	}else{
		var SelDept=""
	}
	if (SelDept==""){
		$.messager.alert("提示","请先选择一个排班科室","info");
		return false;
	}
	//var UserID=$HUI.combobox("#GHUser").getValue();
	var UserID=PageLogicObj.m_SelGHUserID;
	if (UserID==""){
		$.messager.alert("提示","请先选择一个排班员","info");
		return false;
	}
	/*var flag=0
	var udoc=document.getElementById('List_UDoc');
    for (var j=0;j<udoc.length;++j){
		if (udoc.options[j].selected==true)
		{
			flag=1
		}
    }
    if (flag==0){
	    $.messager.alert("提示","请先选择排班医生","info");
	    return false;
    }*/
    var ret=$.cm({
		ClassName:"web.DHCUserGroup",
		MethodName:"delu",
		itmjs:"",
		itmjsex:"",
		name:UserID,
		group:SelDept,
		type:ServerObj.Type,
		dataType:"text",
	},false)
	if (ret!="0"){
		$.messager.alert("提示","删除原有数据错误"+ret,"error");
		return false;
	}

	var udoc=document.getElementById('List_UDoc');
	var findsel=0
    for (var j=0;j<udoc.length;++j){
		if (udoc.options[j].selected==true)
		{ 
			findsel=1
			var docid=udoc.options[j].value; 
			var docdesc=udoc.options[j].text; 
			var ret=$.cm({
				ClassName:"web.DHCUserGroup",
				MethodName:"insu",
				itmjs:"",
				itmjsex:"",
				name:UserID,
				group:SelDept,
				doc:docid,
				type:ServerObj.Type,
				dataType:"text",
			},false)
			if (ret!="0"){
				$.messager.alert("提示",docdesc+"保存数据错误"+ret,"error");
				return false;
			}
	    }    
    }
    if(findsel==0){
		for (var j=0;j<udoc.length;++j){ 
			var docid=udoc.options[j].value; 
			var docdesc=udoc.options[j].text; 
			var ret=$.cm({
				ClassName:"web.DHCUserGroup",
				MethodName:"insu",
				itmjs:"",
				itmjsex:"",
				name:UserID,
				group:SelDept,
				doc:docid,
				type:ServerObj.Type,
				dataType:"text",
			},false)
			if (ret!="0"){
				$.messager.alert("提示",docdesc+"保存错误"+ret,"error");
				return false;
			} 
	    }    
	}
	$.messager.show({title:"提示",msg:"更新完成"});
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}