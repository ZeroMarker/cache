document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){

IntLoc()

var obj=document.getElementById("Save");
if (obj){obj.onclick=Save_Click;}

var obj=document.getElementById("SignBedSystem");
if (obj){obj.onclick=SignBedSystem_Click;}
		
}

function SignBedSystem_Click()
{
	var SignBedSystem=0
	var obj=document.getElementById("SignBedSystem");
	if (obj.checked){SignBedSystem=1}
	var encmeth=""
	var MethObj=document.getElementById("SetIPBookConfig");
	if ((MethObj)&&(MethObj.value!="")){encmeth=MethObj.value}
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"SignBedSystem",SignBedSystem)
		if (rtn==0){
			alert("OK")
		}
	}

	
	
}

function Save_Click()
{
	var iplocdrstr=""
	var obj=document.getElementById("IPLoc");
	if (obj){
		var IPListLeng=obj.length
		for (var i=0;i<IPListLeng;i++){
			if (obj.options[i].selected){if (iplocdrstr==""){iplocdrstr=obj.options[i].value}else{iplocdrstr=iplocdrstr+"^"+obj.options[i].value}}
		}
	}
	if (iplocdrstr==""){
		var vaild = window.confirm("您未选中住院科室是否继续,继续将清空门诊已选权限!");
	}
	var num=0
	var obj=document.getElementById("OPLoc");
	if (obj){
		var IPListLeng=obj.length
		for (var i=0;i<IPListLeng;i++){
			if (obj.options[i].selected){
					var OPLocDr=obj.options[i].value;
					var encmeth=""
					var MethObj=document.getElementById("SetIPBookLocConfig");
					if ((MethObj)&&(MethObj.value!="")){encmeth=MethObj.value}
					if (encmeth!=""){
						var rtn=cspRunServerMethod(encmeth,OPLocDr,iplocdrstr)
						if (rtn==0){
							num=num+1
						}
				}
			}
		}
	}
	if (num==0){alert("未选中有效得门诊科室");return}
	alert("成功保存门诊科室权限:"+num+"条")
}


function IntLoc()
{
	
	var obj=document.getElementById("OPLoc");
	if (obj){
			obj.size=30;
			obj.multiple=true;
			obj.onclick=OPLoc_Click;
			var encmeth=""
			var MethObj=document.getElementById("GetLocByType");
			if ((MethObj)&&(MethObj.value!="")){encmeth=MethObj.value}
			if (encmeth!=""){
				var ListStr=cspRunServerMethod(encmeth,"O^E");var ListStrArry=ListStr.split("!");
				for(var i=0;i<ListStrArry.length;i++){var OneList=ListStrArry[i];if (OneList==""){continue};var varItem = new Option(OneList.split("^")[0],OneList.split("^")[1]);obj.options.add(varItem);}
			}		
	}
	var obj=document.getElementById("IPLoc");
	if (obj){
			obj.size=30;
			obj.multiple=true;
			var encmeth=""
			var MethObj=document.getElementById("GetLocByType");
			if ((MethObj)&&(MethObj.value!="")){encmeth=MethObj.value}
			if (encmeth!=""){
				var ListStr=cspRunServerMethod(encmeth,"I");var ListStrArry=ListStr.split("!");
				for(var i=0;i<ListStrArry.length;i++){var OneList=ListStrArry[i];if (OneList==""){continue};var varItem = new Option(OneList.split("^")[0],OneList.split("^")[1]);obj.options.add(varItem);}
			}
	}
	
}

function OPLoc_Click()
{
	var OPLoc=""
	var obj=document.getElementById("OPLoc");
	if (obj){OPLoc=obj.value}
	var encmeth=""
	var MethObj=document.getElementById("GetIPBookLocConfig");
	if ((MethObj)&&(MethObj.value!="")){encmeth=MethObj.value}
	if ((encmeth!="")&&(OPLoc!="")){
			var configstr=cspRunServerMethod(encmeth,OPLoc)
			var obj=document.getElementById("IPLoc");
			if (obj){
				var IPListLeng=obj.length
				for (var i=0;i<IPListLeng;i++){
					if (("^"+configstr+"^").indexOf("^"+obj.options[i].value+"^")>=0){obj.options[i].selected=true}else{obj.options[i].selected=false}
				}
			}
	}
}

