
///DHCCAbFeeConfig.js
function BodyLoadHandler()
{
	
	var obj=document.getElementById('initbtn')
	if (obj){
		obj.onclick=initbtn_onclick;
	}
	
	var obj=document.getElementById('insfunbtn')
	if (obj){
		obj.onclick=insfunbtn_onclick;
	}
	var obj=document.getElementById('upfunbtn')
	if (obj){
		obj.onclick=upfunbtn_onclick;
	}
	
	var obj=document.getElementById('inswardbtn')
	if (obj){
		obj.onclick=inswardbtn_onclick;
	}
	var obj=document.getElementById('AddDebtn')
	if (obj){
		obj.onclick=AddDebtn_onclick;
	}
	var obj=document.getElementById('DelDebtn')
	if (obj){
		obj.onclick=DelDebtn_onclick;
	}
	var obj=document.getElementById('OECCAT')
	if (obj){
		obj.onchange=OECCAT_onchange;
	}
	var obj=document.getElementById('ARCIC')
	if (obj){
		obj.onchange=ARCIC_onchange;
	}
	
    iniFormClass();
	InitPage();
}
function inswardbtn_onclick(){
	var obj=document.getElementById('wardid');
	var wardid=obj.value;
	if (wardid==""){
		alert("请先选择病区")
		return false;
	}
	 	var obj=document.getElementById('insward');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     	var ret=cspRunServerMethod(encmeth,wardid)
	    if (ret==""){
		    alert("添加病区成功")
		    Find_click();
	    }
	    else{
		    alert(ret);
	    }
     	
     	
}
function insfunbtn_onclick(){
	var obj=document.getElementById('Class');
	var clas=obj.value;
	var obj=document.getElementById('Function');
	var func=obj.value;
	var obj=document.getElementById('CheckDesc');
	var checkdesc=obj.value;
	if ((clas=="")||(func=="")||(checkdesc=="")){
		alert(clas+","+func+","+checkdesc+" 有值为空不能添加主控规则")
		return false;
	}
	 	var obj=document.getElementById('insfun');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     	var ret=cspRunServerMethod(encmeth,clas,func,checkdesc)
	    if (ret==""){
		    alert("添加主规则成功")
		    Find_click();
	    }
	    else{
		    alert(ret);
	    }
     	
     	
}
function upfunbtn_onclick(){
	var obj=document.getElementById('Ind');
	var ind=obj.value;
	var obj=document.getElementById('Class');
	var clas=obj.value;
	var obj=document.getElementById('Function');
	var func=obj.value;
	var obj=document.getElementById('CheckDesc');
	var checkdesc=obj.value;
	if ((clas=="")||(func=="")||(checkdesc=="")){
		alert(clas+","+func+","+checkdesc+" 有值为空不能更新主控规则")
		return false;
	}
	 	var obj=document.getElementById('upfun');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};	
     	var ret=cspRunServerMethod(encmeth,ind,clas,func,checkdesc)
	    if (ret==""){
		    alert("更新规则成功");
		    Find_click();
	    }
	    else{
		    alert(ret);
	    }
     	
     	
}
function getwardid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('wardid');
	obj.value=val[1];

}
function AddDebtn_onclick()
{
	    var obj=document.getElementById('Type');
	    if (obj.value==""){
		    alert("先选中主规则再增加明细")
		    return false;
	    }
	    if (obj.value!="YCFeeCheck"){
		    alert("只有选中主规则才能增加明细")
		    return false;
	    }
	 	var obj=document.getElementById('insdetails');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};
     	var obj=document.getElementById('Ind');
     	var ind=obj.value
		var obj=document.getElementById("OECCAT")
		var oeccat=obj.value
		var ARCICobj=document.getElementById("ARCIC")
		var arcic=ARCICobj.value
		var ARCIMobj=document.getElementById("ARCIM");
		var arcim=ARCIMobj.value;
		
		var arctype="";
		var details=""
        
        var ListNum=ARCIMobj.options.length;
        var ArcimDetailNum=0,ArcimDetailErr=0
        for (i=0;i<ListNum;i++){            
            if (ARCIMobj.options[i].selected==true){
	           var details=ARCIMobj.options[i].value;			   
		       arctype="ARCIM"; 	   			   
			   if ((ind=="")||(details=="")){
			      ArcimDetailErr=ArcimDetailErr+1   
			   }else{   
			      var ret=cspRunServerMethod(encmeth,arctype,ind,details);			   
			      if (ret==0){
			         ArcimDetailNum=ArcimDetailNum+1;	   
			      }
			   }  
			   ///mydata=str.split("^");    
	        }
        }
        
        if (eval(ArcimDetailErr)>0){
	        alert("添加明细失败");
		    Find_click();
	        return;
	    }
        if (eval(ArcimDetailNum)>0){
	        alert("添加明细成功");
		    Find_click();
	        return;
	    }
       
        
        var ARCICListNum=ARCICobj.options.length;
        var ARCICDetailNum=0,ARCICDetailErr=0;
        for (i=0;i<ARCICListNum;i++){
            
            if (ARCICobj.options[i].selected==true){
	           var details=ARCICobj.options[i].value;			   
			   arctype="ARCIC"; 			   
			   if ((ind=="")||(details=="")){
			      ARCICDetailErr=ARCICDetailErr+1
			   }else{    
			      var ret=cspRunServerMethod(encmeth,arctype,ind,details);
			      if (ret==0){
			         ARCICDetailNum=ARCICDetailNum+1;	   
			      }
			   }   
			   ///mydata=str.split("^");    
	        }
        }
        if (eval(ARCICDetailErr)>0){
	        alert("添加子类失败!!");
		    Find_click();
	        return;
	    }
        
        if (eval(ARCICDetailNum)>0){
	        alert("添加子类成功!!");
		    Find_click();
	        return;
	    }
        if ((oeccat!="")&&(ArcimDetailNum==0)&&(ARCICDetailNum==0)){
	       details=oeccat;
	       arctype="OECCAT";
	       if ((arctype=="")||(ind=="")||(details=="")){
	          alert(arctype+","+ind+","+details+",有值不能为空 不能插入");
	          return false;
           }
           var ret=cspRunServerMethod(encmeth,arctype,ind,details)
	       if (ret==0){
		      alert("添加明细成功")
		      Find_click();
	       }

        }
        
        

     	
     	
	
}
function DelDebtn_onclick()
{
	    var obj=document.getElementById('Type');
	    if (obj.value==""){
		    alert("先选中明细规则再删除明细")
		    return false;
	    }
	    if (obj.value!="Details"){
		    alert("只有选中明细规则才能删除明细")
		    return false;
	    }
	 	var obj=document.getElementById('deldetails');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};
     	var obj=document.getElementById('Ind');
     	var ind=obj.value
		var obj=document.getElementById("Type")
		var type=obj.value
		var obj=document.getElementById("ArcType")
		var arctype=obj.value
		var obj=document.getElementById("Details2")
		var details2=obj.value

        alert(arctype+","+ind+","+details2)
        if ((arctype=="")||(ind=="")||(details2=="")){
	        alert(arctype+","+ind+","+details+",有值不能为空 不能删除")
	        return false;
        }

     	
     	var ret=cspRunServerMethod(encmeth,arctype,ind,details2)
	    if (ret==0){
		    alert("删除明细成功");
		    Find_click();
	    }
}
function initbtn_onclick()
{
	 	var obj=document.getElementById('init');
     	if (obj) {var encmeth=obj.value} else {var encmeth=''};
     	var obj=document.getElementById('flag');
     	var flag=obj.value
     	var ret=cspRunServerMethod(encmeth,flag)
	    if (ret==0){
		    alert("初始化成功");
		    Find_click();
	    }
}

function InitPage()
{
	var obj=document.getElementById("ClassIdx")
	var MainIndex=obj.value
	if (MainIndex=="") return;
	var obj=document.getElementById("SubIndex")
	var ChildIndex=obj.value
	var obj=document.getElementById("OECCAT")
	obj.options[MainIndex].selected=true;
	var MainID=obj.options[MainIndex].value;
	iniFormCat(MainID)
	if (ChildIndex=="") return;
	var obj=document.getElementById("ARCIC")
	obj.options[ChildIndex].selected=true;
	var myLoadStr=obj.options[ChildIndex].value;
	iniFormARCIMName(myLoadStr)


} 
function iniFormCat(myLoadStr){
	var obj=document.getElementById("ARCIC");
	if (obj){
		obj.size=3; 
	 	obj.multiple=false;
	 	i=0
	 	var Ins=document.getElementById('getARCIC');
     	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
     	var flag=cspRunServerMethod(encmeth,myLoadStr)
     	var Temp1=flag.split(",")
     	for (var i=0;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^")
			obj.options[i]=new Option(Temp2[2],Temp2[0]);
		}     
	}
}
function iniFormARCIMName(myLoadStr){
	var obj=document.getElementById("ARCIM");
	if (obj){
		obj.size=3; 
	 	obj.multiple=true;
	 	i=0

	 	var Ins=document.getElementById('getARCIM');
     	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
     	var flag=cspRunServerMethod(encmeth,myLoadStr)
     	//alert(flag)
     	var Temp1=flag.split(String.fromCharCode(2))   //
     	for (var i=0;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^")
			var obj=document.getElementById("ARCIM");
			obj.options[i]=new Option(Temp2[2],Temp2[0]);
		}  
		var ARCIMobj=document.getElementById('ARCIM');
  	    if (ARCIMobj){
		   ///ListSelected(ARCIMobj);
	   }   
	}
}
function OECCAT_onchange(){
	var obj=document.getElementById("OECCAT");
	if (obj){
	var myIdx=obj.selectedIndex;
	var myLoadStr=obj.options[myIdx].value;
	var obj=document.getElementById("Ind");
    if (obj) Ind=obj.value;
	var obj=document.getElementById("Type");
    if (obj) type=obj.value;
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCAbFeeConfig&OrderCatStr=&SubIndex=&ClassIdx="+myIdx+"&Ind="+Ind+"&Type="+type;
	/*var obj=document.getElementById('GetOrderItemCat');
	if (obj){
	var catemoth=obj.value;
	//alert(CatStr);
	iniFormCat(myLoadStr)
			}*/
		}
	}
function ARCIC_onchange(){
	var obj=document.getElementById("ARCIC");
	if (obj){
	var myIdx=obj.selectedIndex;
	var myLoadStr=obj.options[myIdx].value;
	//alert(myLoadStr);
	//iniFormLocationName(myLoadStr);
	var obj=document.getElementById("OECCAT");
	if (obj){
	var ClassIdx=obj.selectedIndex;
    var obj=document.getElementById("Ind");
    if (obj) Ind=obj.value;
	var obj=document.getElementById("Type");
    if (obj) type=obj.value;

 	 	
 	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCCAbFeeConfig&OrderCatStr="+myLoadStr+"&SubIndex="+myIdx+"&ClassIdx="+ClassIdx+"&Ind="+Ind+"&Type="+type;
	///var ARCIMobj=document.getElementById('ARCIM');
 	///ListSelected(ARCIMobj);
	return false;
			}
		}
	}
function iniFormClass(){
	var obj=document.getElementById("OECCAT");
	if (obj){
		obj.size=3; 
	 	obj.multiple=false;
	 	i=0
	 	var Ins=document.getElementById('getOECCAT');
     	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
     	var flag=cspRunServerMethod(encmeth,'')
     	var Temp1=flag.split(",")
     	for (var i=0;i<Temp1.length;i++){
			Temp2=Temp1[i].split("^")
			obj.options[i]=new Option(Temp2[2],Temp2[0]);
		}     
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
    var obj=document.getElementById("TIndz"+selectrow);
    var ind=obj.innerText;
    var obj=document.getElementById("Ind");
    obj.value=ind
    var obj=document.getElementById("TClassz"+selectrow);
    var clas=obj.innerText;
    var obj=document.getElementById("Class");
    obj.value=clas
    var obj=document.getElementById("TFunctionz"+selectrow);
    var func=obj.innerText;
    var obj=document.getElementById("Function");
    obj.value=func
    var obj=document.getElementById("TCheckDescz"+selectrow);
    var ckdesc=obj.innerText;
    var obj=document.getElementById("CheckDesc");
    obj.value=ckdesc
    var obj=document.getElementById("TTypez"+selectrow);
    var type=obj.innerText;
    var obj=document.getElementById("Type");
    obj.value=type;
    
     var obj=document.getElementById("TArcTypez"+selectrow);
    var arctype=obj.innerText;
    var obj=document.getElementById("ArcType");
    obj.value=arctype;  
    
    var obj=document.getElementById("TDetails2z"+selectrow);
    var details2=obj.value;
    var obj=document.getElementById("Details2");
    obj.value=details2;
    
    
    var startlink="TbtnStartz"+selectrow
    var stoplink="TbtnStopz"+selectrow
    //alert(eSrc.id)
	if (selectrow !=0) {
				if (eSrc.id==startlink)	{    //启用
				    //alert(adm+","+ind+","+mem)
					var obj=document.getElementById("TUseFlagz"+selectrow);
				    if (obj.innerText=="启用"){
					    alert("已经启用过不需要再启用")
					    return false;
				    }
				    var obj=document.getElementById("TTypez"+selectrow);
				    if (obj.innerText=="Details"){
					    alert("明细不需要启用与停用")
					    return false;
				    }
                    var obj=document.getElementById("TTypez"+selectrow);
                    var type=obj.innerText;
                    var obj=document.getElementById("TIndz"+selectrow);
                    var ind=obj.innerText;
                    var obj=document.getElementById("TDetails2z"+selectrow);
                    var details2=obj.value;
                    
					var obj=document.getElementById('setstat');
					if (obj) {var encmeth=obj.value} else {var encmeth=''};
					var Stat=cspRunServerMethod(encmeth,type,ind,details2,1);     //,LocId,UserId
					if (Stat!=0)	{
						alert(Stat);
						return false;
					}
					else{
						var obj=document.getElementById("TUseFlagz"+selectrow);
						obj.innerText="启用"
						return false;
					}

				}
				if (eSrc.id==stoplink)	{    //停用
				    //alert(adm+","+ind+","+mem)
					var obj=document.getElementById("TUseFlagz"+selectrow);
				    if (obj.innerText=="停用"){
					    alert("已经停用过不需要再停用")
					    return false;
				    }
				    var obj=document.getElementById("TTypez"+selectrow);
				    if (obj.innerText=="Details"){
					    alert("明细不需要启用与停用")
					    return false;
				    }
                    var obj=document.getElementById("TTypez"+selectrow);
                    var type=obj.innerText;
                    var obj=document.getElementById("TIndz"+selectrow);
                    var ind=obj.innerText;
                    var obj=document.getElementById("TDetails2z"+selectrow);
                    var details2=obj.value;
                    
					var obj=document.getElementById('setstat');
					if (obj) {var encmeth=obj.value} else {var encmeth=''};
					var Stat=cspRunServerMethod(encmeth,type,ind,details2,0);     //,LocId,UserId
					if (Stat!=0)	{
						alert(Stat);
						return false;
					}
					else{
						var obj=document.getElementById("TUseFlagz"+selectrow);
						obj.innerText="停用"
						return false;
					}

				}
	}
}
function ListSelected(ARCIMobj)
{
   var ListNum=ARCIMobj.options.length;
   for (i=0;i<ListNum;i++){
      ARCIMobj.options[i].selected=true;
   }	
}
document.body.onload = BodyLoadHandler;