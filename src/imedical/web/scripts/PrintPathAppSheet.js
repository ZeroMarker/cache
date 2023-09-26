function PrintPathAppSheet(tmrowid)
{ 
			//alert("1")
			 var xlApp,xlsheet,xlBook,Template
			 
		     var GetPrescPath=document.getElementById("GetRepPath");
			 if (GetPrescPath) {var encmeth=GetPrescPath.value} 
			 else {var encmeth=''};
			 if (encmeth!="") 
			 {
			 	var TemplatePath=cspRunServerMethod(encmeth);
			 }
			 
			//var TemplatePath="http://172.26.201.2/trakcarelive/trak/med/Templates/"
			Template=TemplatePath+"DHCPisAppSzbd.xls";
			
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730)        
      
      var bldprintfun=document.getElementById("bldprintfun").value;
      var pathInfos=cspRunServerMethod(bldprintfun,tmrowid)
			var pathInfo=pathInfos.split("## ")
			var tmInfo=pathInfo[0]
			var tsInfo=pathInfo[1]
			var twInfo=pathInfo[2]
			var ttInfo=pathInfo[3]
			var age=pathInfo[4]	
			if(tmInfo.split("^")[0]=="1")
		       {
				xlsheet.cells(2,7)=" 术中冰冻标本检查申请单";  
			}
      else
      {
	       xlsheet.cells(2,7)=" 常规病理标本检查申请单";  
      }
	    //号码
	    xlsheet.cells(2,1)="*"+tmrowid+"*";  //条码申请单号
	    xlsheet.cells(3,4)=tmrowid;          //申请单号
	    xlsheet.cells(3,10)=tmInfo.split("^")[32];           //登记号
	    xlsheet.cells(3,17)=tmInfo.split("^")[31];     //医嘱号
	    
	    //基本信息                                                            
	    xlsheet.cells(5,3)=tmInfo.split("^")[13];             //病人姓名
	    var sexInfo=tmInfo.split("^")[16]; 
	    xlsheet.cells(5,10)=sexInfo.split("~")[1];             //病人性别
	    xlsheet.cells(5,15)=age;             //病人年龄
	    xlsheet.cells(5,21)=tmInfo.split("^")[17];			//出生日期
      xlsheet.cells(6,4)=tmInfo.split("^")[52];            //电话号码
      var leixing=tmInfo.split("^")[12]
	    xlsheet.cells(6,11)=leixing.split("~")[1];         //就诊类型
	    var feibie=tmInfo.split("^")[15]
	    xlsheet.cells(6,17)=feibie.split("~")[1];	        //费别
	    xlsheet.cells(7,4)=tmInfo.split("^")[18];          //现住址
	    
	    //申请信息
	    xlsheet.cells(9,4)=tmInfo.split("^")[27];           //申请科室
	    xlsheet.cells(9,14)=tmInfo.split("^")[29];          //申请医生
	    xlsheet.cells(9,21)=tmInfo.split("^")[25];         //申请日期
		
		var tclinicRecord=tmInfo.split("^")[19]
		var item=tclinicRecord.split(";")
		xlsheet.cells(10,4)=item[0].split("手术名称:")[1];        //手术名称
	    xlsheet.cells(10,21)=item[1].split("主术者:")[1];      //主术者
		xlsheet.cells(11,21)=item[5].split("手术间:")[1]      //手术间
		var ssks=item[2].split("手术开始日期:")[1]
	    var osd=ssks.split(" ")[0]
	    if(osd!="")
      	{
	  		var item1=osd.split("/")
      		osd=item1[2]+"-"+item1[1]+"-"+item1[0];   //发现日期
      	}
	    xlsheet.cells(11,5)=osd+" "+ssks.split(" ")[1];      //开始日期
		xlsheet.cells(11,15)=item[3].split("预计送检时间:")[1];      //预计送检日期
		
      xlsheet.cells(13,1)=tsInfo                                                //标本信息
	    xlsheet.cells(15,1)=item[4].split("临床病历:")[1];        //临床病历
	    xlsheet.cells(17,1)=tmInfo.split("^")[20];      //手术所见
//alert(item[6].split("以往病理诊断:")[1])
	   xlsheet.cells(19,1)=item[6].split("以往病理诊断:")[1];      //手术所见
	    xlsheet.cells(21,1)=tmInfo.split("^")[23];      //临床诊断
	    
	    //肿瘤信息
      xlsheet.cells(25,4)=ttInfo.split("^")[1];   //肿瘤部位
      xlsheet.cells(25,12)=ttInfo.split("^")[2];    //肿瘤大小

      xlsheet.cells(25,20)=ttInfo.split("^")[0];    //发现日期
     
      if(ttInfo.split("^")[3]=="Y")   //有无转移)
          xlsheet.cells(26,4)=duihao
      xlsheet.cells(26,8)=ttInfo.split("^")[4]   //转移部位
      if(ttInfo.split("^")[5]=="Y")   //曾否放疗
          xlsheet.cells(26,17)=duihao
      if(ttInfo.split("^")[6]=="Y")   //曾否化疗
          xlsheet.cells(26,22)=duihao
      xlsheet.cells(27,3)=ttInfo.split("^")[7];             //备注
      
      //妇科信息
      xlsheet.cells(29,4)=twInfo.split("^")[0];   //末次月经
      
	    if(twInfo.split("^")[1]=="Y")   //是否绝经
	       xlsheet.cells(29,12)=duihao
	    xlsheet.cells(29,17)=twInfo.split("^")[2];   //胎
	    xlsheet.cells(29,20)=twInfo.split("^")[3];    //产
	    
	    xlsheet.PrintOut 
    	xlBook.Close (savechanges=false);
    	xlBook=null
    	xlApp.Quit();
    	xlApp=null;
    	xlsheet=null 
    	//window.setInterval("Cleanup();",1); 
}