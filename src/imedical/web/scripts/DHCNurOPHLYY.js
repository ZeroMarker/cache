//pengjunfu 2014-12-17

var hlyyType="";
var hlyyFlag="";
function initHLYY()
{
	
	var hlyyInfo=tkMakeServerCall("Nur.DHCNurHLYY","getHLYYInfo",session['LOGON.CTLOCID']);
	hlyyFlag=hlyyInfo.split("^")[0];
	
	if(hlyyFlag==1){
		//hlyyType=hlyyInfo.split("^")[1];
		if(hlyyType=="MK"){
			var dir="../scripts/nurse/hlyy/PassJs/"
			var link = document.createElement('link');
			link.setAttribute("rel","stylesheet");
			link.setAttribute("type","text/css");
			link.setAttribute("href",dir+"McCssAll.css");
			document.getElementsByTagName('head')[0].appendChild(link);
			var script = document.createElement('script');
			script.setAttribute("type","text/javascript");
			script.setAttribute("src",dir+"McConfig.js");
			document.getElementsByTagName('head')[0].appendChild(script);
			var script1 = document.createElement('script');
			script1.setAttribute("type","text/javascript");
			script1.setAttribute("src",dir+"McJsAll.js");
			document.getElementsByTagName('head')[0].appendChild(script1);
			WebServiceInit2(); 
			WebServiceInitCheck();
		}else if(hlyyType=="DT"){
			
			var object = document.createElement('object');
			object.setAttribute("id","CaesarComponent");
			object.setAttribute("CLASSID","clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F");
			object.setAttribute("CODEBASE","../addins/client/dtywzxUIForMS.cab#version1.0.0.1");
			document.getElementsByTagName('head')[0].appendChild(object);
			var dir="../scripts/nurse/hlyy/PassJs/"
			var link = document.createElement('link');
			link.setAttribute("rel","stylesheet");
			link.setAttribute("type","text/css");
			link.setAttribute("href",dir+"McCssAll.css");
			document.getElementsByTagName('head')[0].appendChild(link);
			dtywzxUI(0,0,"");
		}
	}
}
function insertHLYYLight(row)
{
		
	   	if(hlyyFlag==1){
		   	var hlyy=document.getElementById("hlyyz"+row);
		   	var td=hlyy.parentElement;
		   	
		   	var div = document.createElement('div');
		   	div.setAttribute("id","McRecipeCheckLight_"+row);
		   	div.setAttribute("name","McRecipeCheckLight");
		   	div.setAttribute("className","DdimRemark_0");

		   	if(hlyyType=="MK"){
			   	div.ondblclick=(function(row){
			   		return function(){
			   			clickMK(row);
			   		}
			   	})(row);
		   	}else if(hlyyType=="DT"){
			   	div.ondblclick=(function(row){
			   		return function(){
			   			clickDT(row);	
			   		}
			   	})(row);
		   	}
		   	td.appendChild(div);
		   	
	   	}
}
//美康
function clickMK(id)
{
	var Orders="";
	var Para1=""
	var oeori=""
	var oeoriobj=document.getElementById("oeoriIdz"+id).innerText ;
    if (oeoriobj){
	    var oeori=oeoriobj.value
	    oeori=oeori.split("||")[0]+"||"+oeori.split("||")[1];
    }
    if (oeori=="") {return};
    
    var ret=tkMakeServerCall("Nur.DHCNurHLYY","GetPrescInfo",oeori);
    var TempArr=ret.split(String.fromCharCode(2));
    var PatInfo=TempArr[0];
    var MedCondInfo=TempArr[1];
    var AllergenInfo=TempArr[2];
    var OrderInfo=TempArr[3];
   
	var PatArr=PatInfo.split("^");
	var ppi = new Params_Patient_In();
	ppi.PatID = PatArr[0];			// 病人编码
	ppi.PatName = PatArr[1];		// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birth = PatArr[3];			// 出生年月
	ppi.UseTime = PatArr[4];		// 使用时间
	ppi.Height = PatArr[5];			// 身高
	ppi.Weight = PatArr[6];			// 体重
	ppi.VisitID = PatArr[7];		// 住院次数
	ppi.Department = PatArr[8];	    // 住院科室
	ppi.Doctor = PatArr[9];			// 医生
	ppi.OutTime = PatArr[10];		// 出院时间
	McPatientModel = ppi;
    	
    
    var arrayObj = new Array();
	var pri;
  
    var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
    McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++)
	{  
        
	    var OrderArr=OrderInfoArr[i].split("^");
		 
        pri = new Params_Recipe_In();
				

        

		//传给core的?并且由core返回变灯的唯一编号?构造的灯div的id也应该和这个相关联
        pri.Index = "Recipe_"+id;

        pri.DrugCode = OrderArr[1]; 		//药品唯一码
        pri.DrugName = OrderArr[2]; 		//药品名称
        pri.SingleDose =OrderArr[3]; 	//每次用量
        
        pri.DoseUnit = OrderArr[4]; 		//给药单位
        pri.Frequency = OrderArr[5]; 	//用药频次(次/天)
        pri.StartDate = OrderArr[6]; 	//开始时间?格式yyyy-mm-dd
        pri.EndDate = OrderArr[7]; 		//结束时间?格式?yyyy-mm-dd
        pri.RouteDesc = OrderArr[8]; 	//给药途径名称
        pri.RouteID = OrderArr[9]; 		//给药途径编号?同给药途径名称
        pri.GroupTag = OrderArr[10]; 		//成组标记
        pri.IsTemporary = OrderArr[11]; //是否为临时医嘱  1-临时医嘱 0-长期医嘱
        pri.Doctor = OrderArr[12]; 			//医生姓名
        
        //alert(pri.Index+","+pri.DrugCode+","+pri.SingleDose+","+pri.DoseUnit+","+pri.Frequency+","+pri.StartDate+","+pri.EndDate+","+pri.RouteDesc+","+pri.RouteID+","+pri.GroupTag+","+pri.IsTemporary+","+pri.Doctor)	

                /*
				if (Flag==0){
								var obj=websys_getSrcElement(window.event);
								var id=obj.parentElement.id
								var TempArr=id.split("z");
								var Row=TempArr[1];
								var SeqNo=GetColumnData("seqno",1);	
								
		        	            if (pri.Index==SeqNo) pri.WarningTag = "1";
		                     }
		           */
        arrayObj[arrayObj.length] = pri;
	}
	McRecipeDataList = arrayObj;
    
    
	var arrayObj = new Array();
	var pal;
  
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++)
	{
		var AllergenArr=AllergenInfoArr[i].split("^");
        pal = new Params_Allergen_In();
        pal.Index = i; 						//过敏源处方顺序编号?以0开始的唯一索引号?
        pal.AllergenCode = AllergenArr[0]; 	//过敏源编码
        pal.AllergenDesc = AllergenArr[1]; 	//过敏源名称
        pal.AllergenType = AllergenArr[2]; 	//过敏源类型
        pal.Reaction = AllergenArr[3]; 			//过敏症状

        arrayObj[arrayObj.length] = pal;
	}
	//McAllergenDataList = arrayObj;
 
    //alert(pal.Index+","+pal.AllergenCode+","+pal.AllergenDesc+","+pal.AllergenType+","+pal.Reaction)	

 
	//病生状态类数组
	var arrayObj = new Array();
	var pmi;
 
    var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
    

	for(var i=0; i<MedCondInfoArr.length ;i++)
	{	
	    		
		var MedCondArr=MedCondInfoArr[i].split("^");
        pmi = new Params_MedCond_In();
        pmi.Index = i; 	//顺序编号?以0开始的唯一索引号?
        pmi.MedCondCode = MedCondArr[0]; 	//疾病编码
        pmi.MedCondDesc = MedCondArr[1]; 	//疾病名称
        pmi.MedCondType = MedCondArr[2]; 	//疾病类型
        pmi.StartDate = MedCondArr[3]; 		//开始时间
        pmi.StopDate = MedCondArr[4]; 			//结束时间
        pmi.VocabTypeCode = MedCondArr[5];	//疾病Vocab类型编码
        arrayObj[arrayObj.length] = pmi;
	}
	//McMedCondDataList = arrayObj;
	//WebServiceInitCheck();
    //alert(pmi.Index+","+pmi.MedCondCode+","+pmi.MedCondDesc+","+pmi.MedCondType+","+pmi.StartDate+","+pmi.StopDate+","+pmi.VocabTypeCode)	
	FuncSingleRecipeCheck(0);
	//if (Flag==1) FuncRecipeCheck(0,2); //标准审查  FuncRecipeCheckNoLightDiv(0,2)    //
	
	//if (Flag==2) FuncRecipeCheck(0,1); //简洁模式审查
	//if (Flag==3) FuncRecipeCheck(7,2); //妊娠期审查
	//if (Flag==4) FuncRecipeCheck(5,2); //哺乳期审查
}

//大通
function clickDT(id)
{
 	var i;
    var ordstr="";
    var tmpmord="";
    var oeoriobj=document.getElementById("oeoriIdz"+id).innerText ;
    if (oeoriobj){
	    var oeori=oeoriobj.value
	    oeori=oeori.split("||")[0]+"||"+oeori.split("||")[1];
    }
    if (oeori=="") {return};
    dtywzxUI(3,0,"");
	var myPrescXML=tkMakeServerCall("Nur.DHCNurHLYY","GetDaTongPresInfo",oeori);
    myrtn=dtywzxUI(28676,1,myPrescXML);
    var ret=""
	if (myrtn==0) {ret="正常"}
	if (myrtn==1) {ret="一般问题"}
	if (myrtn==2) {ret="严重问题"}
	var obj=document.getElementById("hlyyz"+id);
	obj.innerText=ret
    //alert(myrtn)
    // var objPid=document.getElementById("tPid"+"z"+1);
    // var pid=objPid.value;
    // killTMPafterGetGetDaTong(pid)
        //dtywzxUI(1,0,"");

 	
}

//大通统一调用函数
function dtywzxUI(nCode,lParam,sXML){
   var result;
   result = CaesarComponent.dtywzxUI(nCode, lParam,sXML);

   return result;
}
