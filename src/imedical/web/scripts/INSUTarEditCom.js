var GROUPID=session['LOGON.GROUPID']
var objxmbm,objxmmc,objxmrj
var UserID
var IPAddress
var tsfdlbmdesc=""
function BodyLoadHandler() {
		
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=Updat_click;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click;}
	var obj=document.getElementById("INTIMsfxmbm");
	if (obj){ obj.onchange=INTIMsfxmbmOnChange;}
	var obj=document.getElementById("UpdateExpiryDate");
	if (obj){ obj.onclick=UpdateExpiryDate_click;}
	ini();
	}
	
function ini(){
  	
  	//alert("1234567890")
 	UserID=session['LOGON.USERID']
 	IPAddress=GetLocalIPAddress() 
	/*var obj=document.getElementById("INTIMsfdlbm");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option("诊疗项目","0");
	  obj.options[1]=new Option("西药","1");
	  obj.options[2]=new Option("中成药","2");
	  obj.options[3]=new Option("中草药","3");
	 }
	*/	
	var obj=document.getElementById("INTIMsfxmbm");
	if (obj){
		obj.size=1; 
		obj.multiple=false;
		FillTypeList(obj)

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
	
	//INTIMsfxmbmOnChange()   //2010 07 27 liusf
	/*var obj=document.getElementById("INTIMtjdm");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option("","")
	 
	  obj.options[0]=new Option("",""); //add hwq 2011 09 22
	  obj.options[1]=new Option("甲类","1");
	  obj.options[2]=new Option("乙类","2");
	  obj.options[3]=new Option("丙类","3");
	  obj.options[4]=new Option("国产置换材料","4");
	  obj.options[5]=new Option("适当放宽","5");
	  obj.options[6]=new Option("五免","6");
	  obj.options[7]=new Option("进口置换材料","8");
	  obj.options[8]=new Option("晶体","9");
	  obj.options[9]=new Option("综合类","99");
	  
	  //Zhan 20141204改为从AKA065配置取
		var tmpStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","AKA065");
		if ((tmpStr=="0")||(tmpStr.length<4)){
			alert("请在医保字典表中维护医保的项目等级(代码为AKA065)")
			return false;
		}
		var tmp2Str=tmpStr.split("!")
		var tmplinArr=""
		for(var i=1;i<tmp2Str.length;i++){
			tmplinArr=tmp2Str[i].split("^")
			obj.options[i]=new Option(tmplinArr[3],tmplinArr[2]);
		}
	  }*/
	  
	  
	var obj=document.getElementById("INTIMflzb1");
	if (obj){
	  obj.size=1;
	  obj.multiple=false;
	  obj.options[0]=new Option("",""); //add hwq 2011 09 22
	  obj.options[1]=new Option(t['02'],"Y");
	  obj.options[2]=new Option(t['03'],"N");
	  }
	var obj=document.getElementById("INTIMflzb2");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
      obj.options[0]=new Option("",""); //add hwq 2011 09 22
	  obj.options[1]=new Option(t['02'],"Y");
	  obj.options[2]=new Option(t['03'],"N");
	  }
	  //取数据 2010 03 05
	
	var obj=document.getElementById("rowid");
	if (obj){
		var id=obj.value
		if (id==""){return false}
		var Ins=document.getElementById('Classtxt');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'SetData','',id)
        if (flag=='0') {}
        else{
	        if (flag=='100') {alert("项目已删除或已作废!")}
	        else(alert("ErrNo="+flag))
	    }
	}
	
	
	obj=document.getElementById('INTIMxmrj');
	if (obj){obj.onclick=INTIMxmrj_Onclick;}
	
	}
	
function SetData(value){
	if (value!=""){
		var obj
		Temp=value.split("^")
		//alert(value)

	 	obj=document.getElementById('INTIMsfdlbm');
		//alert(Temp[0])
 		if (obj){
				obj.value=Temp[0]
				
				
	      }
	 	obj=document.getElementById('INTIMsfdlbmdesc');
		//alert(Temp[0])
 		if (obj){
				obj.value=Temp[44]
				tsfdlbmdesc=Temp[44];
					
	      }
	      
        obj=document.getElementById('INTIMsfxmbm');
        if (obj){
	        for (i=0;i<obj.options.length;i++){
		        if (Temp[1]==obj.options[i].value){
			        obj.selectedIndex=i;
			        }
		        }
	        }
	        
	    INTIMsfxmbmOnChange()   //2010 07 27 liusf
        obj=document.getElementById('INTIMxmbm');
        if (obj){obj.value=Temp[2]}
        obj=document.getElementById('INTIMxmmc');
        if (obj){obj.value=Temp[3]}
        obj=document.getElementById('INTIMxmrj');
        if (obj){obj.value=Temp[4]}
        obj=document.getElementById('INTIMtxbz');
        if (obj){obj.value=Temp[5]}
        obj=document.getElementById('INTIMxmlb');
        if (obj){obj.value=Temp[6]}
        obj=document.getElementById('INTIMjx');
        if (obj){obj.value=Temp[7]}
        obj=document.getElementById('INTIMgg');
        if (obj){obj.value=Temp[8]}
        obj=document.getElementById('INTIMdw');
        if (obj){obj.value=Temp[9]}
        obj=document.getElementById('INTIMyf');
        if (obj){obj.value=Temp[10]}
        obj=document.getElementById('INTIMyl');
        if (obj){obj.value=Temp[11]}
        obj=document.getElementById('INTIMsl');
        if (obj){obj.value=Temp[12]}
        obj=document.getElementById('INTIMpzwh');
        if (obj){obj.value=Temp[13]}
        obj=document.getElementById('INTIMbzjg');
        if (obj){obj.value=Temp[14]}
        obj=document.getElementById('INTIMsjjg');
        if (obj){obj.value=Temp[15]}
        obj=document.getElementById('INTIMzgxj');
        if (obj){obj.value=Temp[16]}
        obj=document.getElementById('INTIMzfbl1');
        if (obj){obj.value=Temp[17]}
        obj=document.getElementById('INTIMzfbl2');
        if (obj){obj.value=Temp[18]}
        obj=document.getElementById('INTIMzfbl3');
        if (obj){obj.value=Temp[19]}
        obj=document.getElementById('INTIMbpxe');
        if (obj){obj.value=Temp[20]}
        obj=document.getElementById('INTIMbz');
        if (obj){obj.value=Temp[21]}
        obj=document.getElementById('INTIMtjdm');
        if (obj){
	        for (i=0;i<obj.options.length;i++){
		        if (Temp[22]==obj.options[i].value){
			        obj.selectedIndex=i;
			        }
		        }	        
	        }
        obj=document.getElementById('INTIMflzb1');
        if (obj){
	        for (i=0;i<obj.options.length;i++){
		        if (Temp[23]==obj.options[i].value){
			        obj.selectedIndex=i;
			        }
		        }
	        }
        obj=document.getElementById('INTIMflzb2');
        if (obj){
	        for (i=0;i<obj.options.length;i++){
		        if (Temp[24]==obj.options[i].value){
			        obj.selectedIndex=i;
			        obj.value=obj.options[i].value
			        }
		        }
	        }
        obj=document.getElementById('INTIMflzb3');
        if (obj){obj.value=Temp[25]}
        obj=document.getElementById('INTIMflzb4');
        if (obj){obj.value=Temp[26]}
        obj=document.getElementById('INTIMflzb5');
        if (obj){obj.value=Temp[27]}
        obj=document.getElementById('INTIMflzb6');
        if (obj){obj.value=Temp[28]}
        obj=document.getElementById('INTIMflzb7');
        if (obj){obj.value=Temp[29]}
        obj=document.getElementById('INTIMspmc');
        if (obj){obj.value=Temp[30]}
        obj=document.getElementById('INTIMspmcrj');
        if (obj){obj.value=Temp[31]}
        obj=document.getElementById('INTIMljzfbz');
        if (obj){obj.value=Temp[32]}
        obj=document.getElementById('INTIMyyjzjbz');
        if (obj){obj.value=Temp[33]}
        obj=document.getElementById('INTIMyysmbm');
        if (obj){obj.value=Temp[34]}
        obj=document.getElementById('INTIMfplb');
        if (obj){obj.value=Temp[35]}
        obj=document.getElementById('INTIMDicType');
        if (obj){obj.value=Temp[36]}		
		//总共只有38个字段
	    obj=document.getElementById('INTIMActiveDate');
        if (obj){
	        if (Temp[41]=="") {obj.value=""}
	        else {
		        //obj.value=Temp[41].split("-")[2]+"/"+Temp[41].split("-")[1]+"/"+Temp[41].split("-")[0]
		        obj.value=Temp[41]
		       }
	        }			
		obj=document.getElementById('INTIMUnique');
        if (obj){obj.value=Temp[42]}
        obj=document.getElementById('INTIMExpiryDate');
        if (obj){
	        if (Temp[43]=="") {obj.value=""}
	        else {
		        //obj.value=Temp[43].split("-")[2]+"/"+Temp[43].split("-")[1]+"/"+Temp[43].split("-")[0]
		        obj.value=Temp[43]
		       }
	        }		
	}	
	}

function Delete_click(){
	//return;
	var obj=document.getElementById("rowid");
	if (obj){
		var id=obj.value
		if (id==""){alert("未找到rowid,如果是新增加的项目,为保证项目唯一性,请重新打开页面");return false}		
      if (confirm(t['04'])){
		var Ins=document.getElementById('ClasstxtDelete');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',id)
        if (flag=='0') {
	        //var lnk="websys.default.csp?WEBSYS.TCOMPONENT=INSUTarItemsCom";
	        //location.href=lnk;
	        alert("删除成功!")
	        window.close()
	        }
        else{alert("ErrNo="+flag)}
		}
	  }
	}

function UpdateExpiryDate_click() {
	var ExpiryDate=""
	var obj=document.getElementById("ExpiryDate");
	if (obj) { 
		if (obj.value==""){ExpiryDate=""}
		else {
			//ExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0]
			ExpiryDate=obj.value
			}
		}
	var obj=document.getElementById("rowid");
	if (obj) {
		if (obj.value==""){alert("请选择一条对照数据！");return;}
		if (confirm("要把照失效日期改成 "+"ExpiryDate"+" 吗 ?")){
			var id=obj.value
			alert("id="+id+",ExpiryDate="+ExpiryDate)
			var VerStr=tkMakeServerCall("web.INSUTarContrastCom","UpdateExpiryDate",id,ExpiryDate);
			alert(VerStr)
			if (VerStr<0) {"修改失效日期失败，SQLCODE="+VerStr}
			else {"修改失效日期成功！"}
			}
		}
	
	
	}


	
function SetFPData(value){
	if (value=="") return false;
	var s=value
	var temp=s.split("^")
	var obj=document.getElementById("INTIMsfdlbm");
	if (obj){obj.value=temp[2]
	         
	  //alert("tsfdlbm2="+tsfdlbm)
	}
	var obj=document.getElementById("INTIMsfdlbmdesc");
	if (obj){ obj.value=temp[3]
	          tsfdlbmdesc=temp[3];
	         }
	}

function INTIMsfxmbmOnChange(){
	var obj=document.getElementById("INTIMsfxmbm");
	var Typeobj=document.getElementById("INTIMsfdlbmType");
	Typeobj.value="FeeType" + obj.value
	IniTjdm();
	}
// DingSH 20180329 	
function IniTjdm()
{
	var InsuType=""
	var objsfxmbm=document.getElementById("INTIMsfxmbm");
	if(objsfxmbm){InsuType=objsfxmbm.value}
	
	var obj=document.getElementById("INTIMtjdm");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  obj.options[0]=new Option("","")
	
	  //Zhan 20141204改为从AKA065配置取
		var tmpStr=tkMakeServerCall("web.INSUDicDataCom","GetSys","","","AKA065"+InsuType);
		if ((tmpStr=="0")||(tmpStr.length<4)){
			alert("请在医保字典表中维护医保的项目等级(代码为AKA065"+InsuType+")")
			return false;
		}
		var tmp2Str=tmpStr.split("!")
		var tmplinArr=""
		for(var i=1;i<tmp2Str.length;i++){
			tmplinArr=tmp2Str[i].split("^")
			obj.options[i]=new Option(tmplinArr[3],tmplinArr[2]);
		}
	  }
	
	}	
	
function Updat_click(){
	var obj
	var rowid="";
	var Instring="", ChkValErrMsg=""
	    obj=document.getElementById("rowid");
       if (obj){// alert(obj.value);
       		rowid=obj.value
	       Instring=obj.value}
        obj=document.getElementById('INTIMsfdlbm');
        if (obj){Instring=Instring+"^"+obj.value
             var ErrMsg=CheckVal(obj.value,"收费大类编码");
                 ChkValErrMsg=ErrMsg;
                 obj=document.getElementById('INTIMsfdlbmdesc');
                 var sfdlbmdesc=""
                 if (obj){sfdlbmdesc=obj.value }
                 if (tsfdlbmdesc!=sfdlbmdesc)
                 {
	               alert("收费大类编码非法,请重新选择")  
	               return ;
	             }
        }
        obj=document.getElementById('INTIMsfxmbm');
        if (obj){Instring=Instring+"^"+obj.value}
        obj=document.getElementById('INTIMxmbm');
        if (obj){
	        if (obj.value==""){
		        alert(t['05']);
		        return false;
		        }
	        Instring=Instring+"^"+obj.value
	         var ErrMsg=CheckVal(obj.value,"医保编码");
                 if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
                 
	        }
	       
        obj=document.getElementById('INTIMxmmc');
        if (obj){Instring=Instring+"^"+obj.value
             var ErrMsg=CheckVal(obj.value,"项目名称");
                 if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
           }
        
   
 
        obj=document.getElementById('INTIMxmrj');
        if (obj){
	        if(obj.value.length<1){alert("请输入拼音码!");return;	}
	        Instring=Instring+"^"+obj.value
	        var ErrMsg=CheckVal(obj.value,"拼音码");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMtxbz');
        if (obj){Instring=Instring+"^"+obj.value
        	        var ErrMsg=CheckVal(obj.value,"限制用药标志");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
         }
        obj=document.getElementById('INTIMxmlb');
        if (obj){Instring=Instring+"^"+obj.value
        	    var ErrMsg=CheckVal(obj.value,"项目类别");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
                }
        obj=document.getElementById('INTIMjx');
        if (obj){
	        Instring=Instring+"^"+obj.value
	        	var ErrMsg=CheckVal(obj.value,"剂型");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMgg');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"规格");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMdw');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"单位");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMyf');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"用法");
               if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMyl');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"用量");
               if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMsl');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"数量");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMpzwh');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"批准文号");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMbzjg');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"标准价格");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMsjjg');
        if (obj){Instring=Instring+"^"+obj.value
                var ErrMsg=CheckVal(obj.value,"实际价格");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMzgxj');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"最高限价");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMzfbl1');
        if (obj){
	        Instring=Instring+"^"+obj.value
	        if (!isNaN(obj.value)){}else{alert("自付比例应维护数字格式 \n比如30%应该维护为0.3");return;}
	        if(parseInt(obj.value)>1) {alert("自付比例数据不能大于1！\n比如30%应该维护为0.3");return;}	//Zhan20161028
	    
	            var ErrMsg=CheckVal(obj.value,"自付比例");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
	    }
        obj=document.getElementById('INTIMzfbl2');
        if (obj){
	        Instring=Instring+"^"+obj.value
	        if (!isNaN(obj.value)){}else{alert("自付比例2应维护数字格式 \n比如30%应该维护为0.3");return;}
			if(parseInt(obj.value)>1) {alert("自付比例数据不能大于1！\n比如30%应该维护为0.3");return;} //Zhan20161028
	            var ErrMsg=CheckVal(obj.value,"自付比例2");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
	    }
        obj=document.getElementById('INTIMzfbl3');
        if (obj){
	        Instring=Instring+"^"+obj.value
	        if (!isNaN(obj.value)){}else{alert("自付比例3应维护数字格式 \n比如30%应该维护为0.3");return;}
	        if(parseInt(obj.value)>1) {alert("自付比例数据不能大于1！\n比如30%应该维护为0.3");return;} //Zhan20161028
	    var ErrMsg=CheckVal(obj.value,"自付比例3");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
	    }
        obj=document.getElementById('INTIMbpxe');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"报批限额");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMbz');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"备注");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMtjdm');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"项目等级");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb1');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标1");
               if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb2');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标2");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb3');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标3");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb4');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标4");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb5');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标5");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb6');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标6");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMflzb7');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"分类指标7");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMspmc');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"商品名称");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMspmcrj');
        if (obj){Instring=Instring+"^"+obj.value
                var ErrMsg=CheckVal(obj.value,"商品名拼音码");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMljzfbz');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"累计增负标志");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMyyjzjbz');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"医院增加标志");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMyysmbm');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"医院三目编码");
               if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMfplb');
        if (obj){Instring=Instring+"^"+obj.value
        var ErrMsg=CheckVal(obj.value,"发票类别");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMDicType');
        if (obj){Instring=Instring+"^"+obj.value
                 var ErrMsg=CheckVal(obj.value,"目录类别");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        Instring=Instring+"^"+UserID+"^"+""+"^"+""+"^"+IPAddress;
        //alert(IPAddress)
        var tmpActDate=""
        obj=document.getElementById('INTIMActiveDate');
         if (obj){
	        //if (!IsValidDate(obj)) {alert("生效日期非法!");return;}
	        if (obj.value==""){var INTIMActiveDate="" }
	        else {
		        //var INTIMActiveDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] 
		        var INTIMActiveDate=obj.value
		       }
	        Instring=Instring+"^"+INTIMActiveDate;
	        tmpActDate=INTIMActiveDate
	        }
	    if(""==tmpActDate){alert("请选择生效日期!");return;}
        obj=document.getElementById('INTIMUnique');
        if (obj){Instring=Instring+"^"+obj.value
                var ErrMsg=CheckVal(obj.value,"中心唯一标识码");
                if (ErrMsg!="") ChkValErrMsg=ChkValErrMsg+"\r\n"+ErrMsg;
        }
        obj=document.getElementById('INTIMExpiryDate');
        if (obj){
	        //if (!IsValidDate(obj)) {alert("失效日期非法!");return;}
	        var INTIMExpiryDate=""
	        if (obj.value==""){INTIMExpiryDate="" }
	        else {
		        //INTIMExpiryDate=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0] 
		        INTIMExpiryDate=obj.value
		        }
	        Instring=Instring+"^"+INTIMExpiryDate
	        if(""!=INTIMExpiryDate){
		        if(tmpActDate.split("-").length>1){
		    	 if(eval(tmpActDate.split("-").join(''))>=eval(INTIMExpiryDate.split("-").join(''))){
			    	 	alert("生效日期必须小于失效日期!");return;	
			    	 }
			    }
		        if(tmpActDate.split("/").length>1){
			        var tmpdateAr=tmpActDate.split("/")
			        var tmpExpdateAr=INTIMExpiryDate.split("/")
		    	 if(eval(tmpdateAr[2]+tmpdateAr[1]+tmpdateAr[0])>=eval(tmpExpdateAr[2]+tmpExpdateAr[1]+tmpExpdateAr[0])){
			    	 	alert("生效日期必须小于失效日期!");return;	
			    	 }
		        }
			 }
	    }
	    
	     //验证数据是否有特殊字符DingSH 20171219
         if (ChkValErrMsg.replace(/\r\n/g,"")!=""){
	         alert(ChkValErrMsg)
	         return ;
	         }
        
        
		//判断是否有相同的项目,Zhan 20160830
		var savecode=tkMakeServerCall("web.INSUTarItemsCom","CheckInsu",Instring)
		if((savecode>0)&(savecode!=rowid)){
			alert("有相同的医保项目,不允许保存，")
			return;
		}

        var Ins=document.getElementById('ClasstxtUpdate');
        if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
        var flag=cspRunServerMethod(encmeth,'','',Instring)
        //alert(flag)
        if (flag=="0") {
	        alert("更新成功-OK")
	        //history.go(-1)
	        window.close()
	        //self.location.reload();
	        }
        else{alert("更新失败,ErrNo="+flag)}
        
	}
	
//数据校验，校验是否特殊字符 DingSH 20171219
function CheckVal(InArgStr,InArgName)
{
	var ErrMsg="";
	var specialKey = "\^\'\"\n"; 
	var isFlag=""
	//alert(specialKey)
	for (var i = 0; i < InArgStr.length; i++) {
      if(specialKey.indexOf(InArgStr.substr(i, 1))>=0)
      {
	      isFlag="1";
	   } 
    } 
    
    if (isFlag=="1") ErrMsg="【"+InArgName+"】"+"不允许有"+"\^" +"  "+"\'"+"  "+"\""+" 回车 等字符" ;
    //alert(ErrMsg)
	return ErrMsg ;
	
}	

//根据项目名称自动加载项目热键  DingSH  20171219
function INTIMxmrj_Onclick()
{
	//w ##class(web.DHCINSUPort).GetCNCODE("东华",4,"")
	var xmrj=""
	obj=document.getElementById('INTIMxmmc');
	if (obj)xmrj=tkMakeServerCall("web.DHCINSUPort","GetCNCODE",obj.value,"4","");
    obj=document.getElementById('INTIMxmrj');
	if (obj)if(obj.value==""){obj.value=xmrj};
	
	return ;
}


document.body.onload = BodyLoadHandler;
