var GROUPID=session['LOGON.GROUPID']
var i=0
function BodyLoadHandler() {	
	ini();
	websys_setfocus('txt')
	var obj=document.getElementById("txt");
	if (obj){
		obj.focus();
		obj.onkeydown=Key;	
	}
	var obj=document.getElementById("Query");
	if (obj){
		obj.focus();
		obj.onclick=Query_onclick;	
	}
          //SepPage('fINSUTarItemsCom','tINSUTarItemsCom',50);  //����DHCCPMSepPage.js
	//ͬ��HISĿ¼
	var obj=document.getElementById("UpdateInsuTarCon");
	if (obj){ obj.onclick=UpdateInsuTarCon;}
 }

function Key(){
	if (window.event.keyCode==13){	
		
		var obj=document.getElementById("txt");
		if (obj)
		{
			if(obj.value=="")
			{
				var obj=document.getElementById("Class");
				if(obj){obj.value="0"}
			}
		}
		var obj=document.getElementById("Query");
		if (obj) {obj.focus();}
	 }	
 }

 
function ini(){
var obj=document.getElementById("Type");
	if (obj){
		
	  obj.size=1; 
	  obj.multiple=false;
	  var Flag=FillTypeList(obj)
	  if (Flag){
		var n=obj.length
		var Typeobj=document.getElementById("TypeSave");
		if(Typeobj.value==""){
			obj.options[0].selected=true
		}
		else{
			for (var i =0;i<n;i++){
				if(obj.options[i].value==Typeobj.value){
				obj.options[i].selected=true
				}
			}
		}
	  }
	}
	var obj=document.getElementById("Class");
	if (obj){	
	  obj.size=1; 
	  obj.multiple=false;

	  obj.options[0]=new Option(t['msClass0'],"0");
	  obj.options[1]=new Option(t['msClass1'],"1");
	  obj.options[2]=new Option(t['msClass2'],"2");
	  obj.options[3]=new Option(t['msClass3'],"3");
	  //obj.options[4]=new Option(t['msClass4'],"4");
		}
	var obj=document.getElementById("Class");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("ClassSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}

	/*var obj=document.getElementById("Type");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Typeobj=document.getElementById("TypeSave");
		  if(obj.options[i].value==Typeobj.value){
		  obj.options[i].selected=true
		  }
	      }
	}

	var obj=document.getElementById("Class");
	if (obj){
      var n=obj.length
      for (var i =0;i<n;i++){
		  var Classobj=document.getElementById("ClasSsave");
		  if(obj.options[i].value==Classobj.value){
			  
		  obj.options[i].selected=true
		  }
	      }
	 }*/
	
	}

function Query_onclick()
{
	
	var obj=document.getElementById("txt");
		if (obj)
		{
			if(obj.value=="")
			{
				var obj=document.getElementById("Class");
				if(obj){obj.value="0"}
			}
		}
		Query_click();
}



//����Ŀ¼ͬ����ť
function UpdateInsuTarCon()
{
	alert("��ʼͬ��HISĿ¼")
	var TypeobjTmp=document.getElementById("Type");
	var DHCINSUBLL = new ActiveXObject("DHCINSUBLL.INSUWHB"); //�ܵ���ҽ��
	var TypeTmp=TypeobjTmp.value
	var OutStr=DHCINSUBLL.UpdateInsuTarCon(TypeTmp) 
}


	
document.body.onload = BodyLoadHandler;