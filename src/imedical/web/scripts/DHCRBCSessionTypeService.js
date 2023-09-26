document.body.onload = BodyLoadHandler;
var comb_Service;
function BodyLoadHandler() {
	comb_Service = dhtmlXComboFromSelect("Service");
	comb_Service.enableFilteringMode(true);
		document.onkeydown=nextfocus1;	
	$('SESSDesc').multiple=false;
	$("SessionServer").multiple=false;
	$('SESSDesc').onchange = function(){
		ClearAllList($('SessionServer'));
		var encmeth =$V('GetSessionServerMethed');
		if(encmeth!=""){
		var result = cspRunServerMethod(encmeth,this.value);
		var result=eval(result);
		
		var sessionServer = $("SessionServer");
		for(var i=0 ;i<result.length;i++){
		 sessionServer.options[sessionServer.length] = new Option(result[i].split("^")[1],result[i].split("^")[0]);
		}
	}
}
		
	$("BtnSessionDelete").onclick=function(){
		if($("SessionServer").value==""){
		alert("请选择");}
		else{
		var entityInfo=["ID="+$V("SessionServer"),
								"SERParRef="+$V("SessionServer"),
								"SERRBCServiceDR="+comb_Service.getSelectedValue()
                ];
           
		var resource=Card_GetEntityClassInfoToXML(entityInfo);
		var encmeth =$V('SessionDeletMethed');
		if(encmeth!=""){
		var result = cspRunServerMethod(encmeth,resource);
		if(result=="0"){
		$("SessionServer").removeChild($("SessionServer").options[$("SessionServer").selectedIndex] );}
	  else alert("删除失败");
		}
	}
}
		

	
	$('BtnSessionAdd').onclick = function(){
		if($V("SESSDesc")==""){
			alert("请选择挂号职称")
		}
		if(comb_Service.getSelectedValue==""){
			alert("请选择级别服务")
		}
		if($V("SESSDesc")!=""){
		  	var entityInfo=["ID="+$V("SESSDesc"),
								"SERParRef="+$V("SESSDesc"),
								"SERRBCServiceDR="+comb_Service.getSelectedValue()
                ];
                alert(entityInfo);
			var resource=Card_GetEntityClassInfoToXML(entityInfo);
		  	var encmeth=$V('SessionAddMethed');
			if(encmeth!=''){
				var returnvalue=cspRunServerMethod(encmeth,resource);
		  		if(returnvalue=="0")
		  		{
		  			$('SESSDesc').onchange();
		  		}
		 			 else alert("更新失败");
		 		}
		}
	}
  quickK.f9=$('BtnSessionAdd').onclick;
  quickK.addMethod();
}

function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

function nextfocus1() {	
	var eSrc=window.event.srcElement;	
	//var t=eSrc.type;		&& t=='text'
	var key=websys_getKey(e);	
	if (key==13) {	
		
		if (eSrc.name=='CardNo')
		{
			SetCardNoLength();
		}
		websys_nexttab(eSrc.tabIndex);
	}
}