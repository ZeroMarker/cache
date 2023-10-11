$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	if(ServerObj.DocCureUseBase=="1"){
		$HUI.switchbox(".checkusebase").setActive(false);	
	}
	if (ServerObj.GroupRowId!=""){
		var Node="DocCure"+ServerObj.page+"_UIConfigObj_Group";
		var SubNode=ServerObj.GroupRowId;
	}else{
		var Node="DocCure"+ServerObj.page+"_UIConfigObj";
		var SubNode=session['LOGON.USERID']+'Z'+session['LOGON.GROUPID'];
	}
	$.cm({
		ClassName:"web.DHCDocConfig",
		MethodName:"GetConfigNode1",
		Node:Node, SubNode:SubNode,
		dataType:"text"
	},function(UIConfigObj){
		if (UIConfigObj==""){UIConfigObj="{}";}
		var data = eval('(' + UIConfigObj + ')');
		$("#layoutConfig1").radio("setValue",data['DocCure'+ServerObj.page+'_layoutConfig1']);
		$("#layoutConfig2").radio("setValue",data['DocCure'+ServerObj.page+'_layoutConfig2']);
		
		if ((!data['DocCure'+ServerObj.page+'_AppListScale'])||(data['DocCure'+ServerObj.page+'_AppListScale']=="")){
			data['DocCure'+ServerObj.page+'_AppListScale']="60"
		}
		$("#AppListScale").slider('setValue',data['DocCure'+ServerObj.page+'_AppListScale']);
		
		if ((!data['DocCure'+ServerObj.page+'_SingleAppointMode'])||(data['DocCure'+ServerObj.page+'_SingleAppointMode']=="")){
			$HUI.switchbox("#SingleAppointMode").setValue(false);
		}else{
			var val=data['DocCure'+ServerObj.page+'_SingleAppointMode'];
			if(val=="1"){
				$HUI.switchbox("#SingleAppointMode").setValue(true);
			}else{
				$HUI.switchbox("#SingleAppointMode").setValue(false);
			}
		}
		if ((!data['DocCure'+ServerObj.page+'_ScheuleGridListOrTab'])||(data['DocCure'+ServerObj.page+'_ScheuleGridListOrTab']=="")){
			$HUI.switchbox("#ScheuleGridListOrTab").setValue(false);
		}else{
			var val=data['DocCure'+ServerObj.page+'_ScheuleGridListOrTab'];
			if(val=="1"){
				$HUI.switchbox("#ScheuleGridListOrTab").setValue(true);
			}else{
				$HUI.switchbox("#ScheuleGridListOrTab").setValue(false);
			}
		}
	});
	
}
function InitEvent(){
	$("#BSave").click(BSaveClickHandle);
	$("#BRestoreDefault").click(BRestoreDefaultClickHandle);
	document.onkeydown = Doc_OnKeyDown;
}
function Doc_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
   if (!websys_cancelBackspace(e)) return false;
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
        e.preventDefault();   
    }  
}
function BSaveClickHandle(){
	var UserID=session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	$("#fUIConfig").form("submit",{
		url : "doccure.config.data.csp?action=Config_Set&UserID="+UserID+"&GroupID="+ServerObj.GroupRowId+"&LoginGroupRowId="+ServerObj.LoginGroupRowId+"&HospId="+HospId+"&page="+ServerObj.page,
		onSubmit: function(param){
		    param.layoutConfig1=$("#layoutConfig1").radio('getValue')?true:false;
			param.layoutConfig2=$("#layoutConfig2").radio('getValue')?true:false;	
			param.AppListScale=$("#AppListScale").slider('getValue');
			var SingleAppointMode=0;
			if ($HUI.switchbox("#SingleAppointMode").getValue()) {
				SingleAppointMode=1;
			}
			param.SingleAppointMode=SingleAppointMode;
			var ScheuleGridListOrTab=0;
			if ($HUI.switchbox("#ScheuleGridListOrTab").getValue()) {
				ScheuleGridListOrTab=1;
			}
			param.ScheuleGridListOrTab=ScheuleGridListOrTab;
		},
		success:function(data){
			var data = eval('(' + data + ')');
			if (data.success) {
				$.messager.popover({msg: data.message,type:'success',timeout: 1000});
			}
		}
	});
}

function tipFormatter(value){
	return value+"%";
}
function BRestoreDefaultClickHandle(){
	var UserID=session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	$("#fUIConfig").form("submit",{
		url : "doccure.config.data.csp?action=RestoreDefault&UserID="+UserID+"&GroupID="+ServerObj.GroupRowId+"&LoginGroupRowId="+ServerObj.LoginGroupRowId+"&HospId="+HospId,
		onSubmit: function(param){
		},
		success:function(data){
			var data = eval('(' + data + ')');
			if (data.success) {
				$.messager.alert("提示",data.message,"info",function(){
					window.location.reload();
				})
					
			}
		}
	});
}