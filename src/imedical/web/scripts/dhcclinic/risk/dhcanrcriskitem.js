Ext.onReady(function(){
    Ext.QuickTips.init();
    var bd = Ext.getBody();
  
    var _DHCANRRisk=ExtTool.StaticServerObject('web.DHCANRRisk');
    var tmpDisplayLocId="^31^33^40^46^";  //除去个性科室调用基本外科显示科室模板(胸外科、骨科、血管外科、眼科)
    if(tmpDisplayLocId.indexOf("^"+session['LOGON.CTLOCID']+"^")<0){var DisplayLocId="30"}
    else {var DisplayLocId=session['LOGON.CTLOCID']};
    //var DisplayLocId="40"
    //---------------------------A级风险管理-------------------------------------------
    var DisplayCheck=_DHCANRRisk.LoadANRCheck("A",DisplayLocId);
    var DisplayListA=DisplayCheck.split(String.fromCharCode(1));
    //alert(DisplayListA);
   	var AGC=""
   	var DisplayArrA=new Array();   	
   	LoadDisplayItem(DisplayArrA,DisplayListA);   	
   	function LoadDisplayItem(DisplayArr,DisplayList)
	{  	
   	for(var i=0;i<DisplayList.length;i++)
   	{
	   	var DisCode=DisplayList[i].split("^")[1];
	   	var DisDesc=DisplayList[i].split("^")[2];	 
	   	var tmpDisType=DisplayList[i].split("^")[11]; 
	   	var checkType=tmpDisType.split("|")[0];
	   	var checkValue=tmpDisType.split("|")[1];
	 	//var normalType=tmpDisType.split("|")[2];
	 	if (!tmpDisType.split("|")[2]) {var normalType="";}
	 	else {var normalType=tmpDisType.split("|")[2]}
	   	var normalValue=tmpDisType.split("|")[3];
	  	//var noteType=tmpDisType.split("|")[4];
	  	if (!tmpDisType.split("|")[4]) {var noteType="";}
	 	else {var noteType=tmpDisType.split("|")[4]}
	   	var noteValue=tmpDisType.split("|")[5];
	   	var samplieBtn=tmpDisType.split("|")[6];
	 	//if (checkType==""){continue;};
	 	var tmpRowCol=DisplayList[i].split("^")[13];
	 	var tmpRow=tmpRowCol.split("|")[0];
	 	var tmpRowHeight=tmpRowCol.split("|")[1];
	 	var tmpCol=tmpRowCol.split("|")[2];
	 	var tmpColWeight=tmpRowCol.split("|")[3];	 	
	 	if ((tmpRow!="")&&(tmpCol!=""))
	 	{
		 	//tmpRow=tmpRow-1;
		 	tmpCol=tmpCol-1
		 	if (!DisplayArr[tmpRow]) {DisplayArr[tmpRow]=new Array();}
		 	if 	(tmpRow==0)
		 	{
			 	DisplayArr[tmpRow][tmpCol]='<th width="20%" colspan='+tmpColWeight+'>'+DisDesc+'</th>'			 
		 	}
		 	else
		 	{ 	
	 		if (samplieBtn=="Y")
	 		{
		 		DisplayArr[tmpRow][tmpCol]='<td colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'>'+DisDesc+'<input type='+checkType+' code='+DisCode+' anrcType='+checkValue+'></td>'
		 		
	 		}
	 		else
	 		{
		 		if ((DisDesc!=""))
	 			{
		 			DisplayArr[tmpRow][tmpCol]='<td>'+DisDesc+'</td>'
	 			}
	 			if (checkType!="")
	 			{
		 			DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol]+	'<td colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' code='+DisCode+' anrcType='+checkValue+'></td>'
	 			}
	 			if (normalType!="")
	 			{
		 			DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol]+	'<td><input type='+normalType+' code='+DisCode+' anrcType='+normalValue+'></td>'
	 			}
	 			if (noteType!="")
	 			{
		 			DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol]+	'<td><input size="80" type='+noteType+' code='+DisCode+' anrcType='+noteValue+'></td>'
	 			}	 	
	 		}
		 	} 
	 	}  	
   	}
	}
   	for(i=0;i<DisplayArrA.length;i++)
	{
		//alert(DisplayArr[i]);
		if (DisplayArrA[i])
		{
			AGC=AGC+'<tr>'
			for(j=0;j<DisplayArrA[i].length;j++)
			{
				AGC=AGC+DisplayArrA[i][j];
			}
			AGC=AGC+'</tr>'			
		}		
	}
	//alert(AGC);
   	var pnlRiskADetail=new Ext.Panel({
	    id:'pnlRiskADetail',
		layout:'form',
		//frame:true,
		//width:1100,
        items:[
        
        ]
        
        ,html:'<table width="100%" border="1" cellpadding="2" cellspacing="0">'
        //+'<tr><th>项目</th><th>是否检查</th><th>是否正常</th><th>如不正常,简述处理</th></tr>'      
        +AGC               
       /*
        +'<tr>'
        +	'<td>输血八项</td>'
        +	'<td><input type="checkbox" code="HBSAG+HCVAB" anrcType="Checked"></td>'
		+	'<td><input type="checkbox" code="HBSAG+HCVAB" anrcType="Result"></td>'
        +	'<td><input type="textbox" code="HBSAG+HCVAB" anrcType="Note"></td>'
        +'</tr>'
        +'<tr>'
        +	'<td colspan="3">配血<input type="checkbox" code="WithBlood" anrcType="Checked"></td>'
        +	'<td>手术签字<input type="checkbox" code="SurgerySign" anrcType="Checked"></td>'
        +'</tr>'
        +'<tr>'
        +	'<td colspan="3">术前带药<input type="checkbox" code="DrugBefore" anrcType="Checked"></td>'
        +	'<td>上级医师签字<input type="checkbox" code="HigherSurgerySign" anrcType="Checked"></td>'
        +'</tr>'*/
        +'</table>'
    });   
    var pnlSignA=new Ext.Panel({
	    id:'pnlSignA',
		layout:'form',
		//frame:true,
        items:[
        ]
        ,html:'<table width="100%" height=30 border="1" cellpadding="2" cellspacing="0">'
        +'<tr>'
        +	'<td width="50%">住院医师签字及日期</td><td>主治医师签字及日期</td>'
        +'</tr>'        
        +'</table>'
    });     
    var pnlRiskA=new Ext.Panel({
	    id:'pnlRiskA',
		frame:true,
        items:[
        	pnlRiskADetail,
        	pnlSignA
        ]

    });
    
    //---------------------------B级风险管理-------------------------------------------
    /*var tmpDisplayLocId="^33^";  //除去个性科室调用血管外科显示模板(个性科室)
    if(tmpDisplayLocId.indexOf("^"+session['LOGON.CTLOCID']+"^")<0)
    {
	    var DisplayCheck=_DHCANRRisk.LoadANRCheck("B^C",DisplayLocId);
	}
    else
    {
	    var DisplayCheck=_DHCANRRisk.LoadANRCheck("B^C^D",DisplayLocId);
	}*/   
    var DisplayCheck=_DHCANRRisk.LoadANRCheck("B^C^D^E",DisplayLocId);
    var DisplayListB=DisplayCheck.split(String.fromCharCode(1));   		
   	var AGC=""
   	function LoadDisplayItemB(DisplayArr,DisplayList)
	{  	
   	for(var i=0;i<DisplayList.length;i++)
   	{
	   	var DisCode=DisplayList[i].split("^")[1];
	   	var DisDesc=DisplayList[i].split("^")[2];
	   	var AnrcmcDr=DisplayList[i].split("^")[3];
	   	var AnrcmcDesc=DisplayList[i].split("^")[4];	 
	   	var tmpDisType=DisplayList[i].split("^")[11];
	   	var checkType=tmpDisType.split("|")[0];
	   	var checkValue=tmpDisType.split("|")[1];
	 	//var normalType=tmpDisType.split("|")[2];
	 	if (!tmpDisType.split("|")[2]) {var normalType="";}
	 	else {var normalType=tmpDisType.split("|")[2]}
	   	var normalValue=tmpDisType.split("|")[3];
	  	//var noteType=tmpDisType.split("|")[4];
	  	if (!tmpDisType.split("|")[4]) {var noteType="";}
	 	else {var noteType=tmpDisType.split("|")[4]}
	   	var noteValue=tmpDisType.split("|")[5];
	   	//if (noteType=="textbox"){alert(noteType+"**"+noteValue)}
	   	var samplieBtn=tmpDisType.split("|")[6];
	 	//if (checkType==""){continue;};
	 	var tmpRowCol=DisplayList[i].split("^")[13];
	 	var tmpRow=tmpRowCol.split("|")[0];
	 	var tmpRowHeight=tmpRowCol.split("|")[1];
	 	var tmpCol=tmpRowCol.split("|")[2];
	 	var tmpColWeight=tmpRowCol.split("|")[3];	 	
	 	if ((tmpRow!="")&&(tmpCol!=""))
	 	{
		 	//tmpRow=tmpRow-1;
		 	tmpCol=tmpCol-1
		 	if (!DisplayArr[tmpRow]) {DisplayArr[tmpRow]=new Array();}
		 	if 	(tmpRow==0)
		 	{
			 	if (DisDesc=="所属") DisplayArr[tmpRow][tmpCol]='<th width="5%" colspan='+tmpColWeight+'>'+DisDesc+'</th>'
			 	else DisplayArr[tmpRow][tmpCol]='<th width="10%" colspan='+tmpColWeight+'>'+DisDesc+'</th>'
		 	}
		 	else
		 	{	 	
	 		if (samplieBtn=="Y")
	 		{
		 		DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'>'+DisDesc+'<input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'></td>'
		 		
	 		}
	 		else
	 		{
		 		//if((DisDesc=="冠脉 CTA")||(DisDesc=="心肌核素")){alert(checkType+"||"+noteType+"||"+AnrcmcDr)};		 		
		 		if ((checkType=="")&&(noteType=="")&&(normalType=="")&&(DisDesc!=""))
	 			{
		 			DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'>'+DisDesc+'</td>'
	 			}
	 			if ((checkType!="")&&(noteType==""))
	 			{
		 			//'<td><input type="checkbox" name="hypertension" value="checkbox">高血压</td>'
		 			/*if ((AnrcmcDesc=="C")||(AnrcmcDesc=="D")||(AnrcmcDesc=="E"))
		 			{
			 			if (AnrcmcDesc=="D")
			 			{
			 				DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc+'</td>'
			 			}
			 			else DisplayArr[tmpRow][tmpCol]='<td style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc+'</td>'
		 			}
		 			else DisplayArr[tmpRow][tmpCol]='<td colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc+'</td>' 
	 				*/
	 				DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc+'</td>'
	 			}
	 			if ((checkType!="")&&(noteType!=""))
	 			{
		 			/*if ((AnrcmcDesc=="C")||(AnrcmcDesc=="D")||(AnrcmcDesc=="E"))
		 			{
			 			if (AnrcmcDesc=="D")
			 			{				 			
		 					DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc
	 						DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol] + '<input type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
			 			}
			 			else
			 			{
				 			DisplayArr[tmpRow][tmpCol]='<td style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc
	 						DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol] + '<input type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
			 			}
			 			
		 			}
		 			else
		 			{
			 			DisplayArr[tmpRow][tmpCol]='<td colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc
	 					DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol] + '<input type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
		 			}*/
		 			DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input type='+checkType+' name='+DisCode+' anrcType='+checkValue+'>'+DisDesc
	 				DisplayArr[tmpRow][tmpCol]=DisplayArr[tmpRow][tmpCol] + '<input size="35" type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
			 			
	 			}
	 			if ((checkType=="")&&(noteType!="")&&(normalType==""))
	 			{
		 			if (session['LOGON.CTLOCID']=="31")
		 			{
			 			DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'><input size="60" type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
		 			}
		 			else DisplayArr[tmpRow][tmpCol]='<td id='+AnrcmcDesc+' style="display:none;" colspan='+tmpColWeight+' rowspan='+tmpRowHeight+'>'+DisDesc+'<input size="60" type='+noteType+' name='+DisCode+' anrcType='+noteValue+'></td>'
	 			}	 				
	 		}
		 	} 
	 	}  	
   	}
	}
   	if (DisplayListB!="")
   	{
   		var DisplayArrB=new Array();
   		LoadDisplayItemB(DisplayArrB,DisplayListB);
   	   
   	
   	for(i=0;i<DisplayArrB.length;i++)
	{
		//alert(DisplayArrB[i]);
		if(typeof(DisplayArrB[i])!='undefined')
		{
			AGC=AGC+'<tr>'
			for(j=0;j<DisplayArrB[i].length;j++)
			{				
				if (j!=0)
				{
					if(typeof(DisplayArrB[i][j])=='undefined')
					{						
						AGC=AGC+'<td></td>'						
					}
					else AGC=AGC+DisplayArrB[i][j];
				}
				else if(typeof(DisplayArrB[i][j])!='undefined'){AGC=AGC+DisplayArrB[i][j]};
			}
			AGC=AGC+'</tr>'			
		}
		else
		{
			AGC=AGC+'<tr><td></td></tr>'
		}		
	}
	//alert(AGC);
  }
   	var pnlRiskBDetail=new Ext.Panel({
	    id:'pnlRiskBDetail',
		layout:'form',
		//frame:true,
        items:[
        ]
        ,html:'<table width="100%" border="1" cellpadding="2" cellspacing="0">'
        //+'<tr><th></th><th>特殊危险因素</th><th colspan="2">检查/会诊</th><th>基础处理</th></tr>'        
        +AGC        
       	/*
 		+'<tr>'
		+	'<td rowspan="3">内分泌</td>'
        +	'<td><input type="checkbox" name="diabetes" value="checkbox">糖尿病</td>'
		+	'<td><input type="checkbox" name="bloodSugarMonitoring" value="checkbox">血糖监测</td>'
        +	'<td>异常<input type="checkbox" name="abnormal13" value="checkbox"></td>'
        +	'<td><input type="checkbox" name="insulinize" value="checkbox">胰岛素治疗</td>'
        +'</tr>'
 		+'<tr>'
        +	'<td></td>'
		+	'<td onclick="singleClick(this);"><input type="checkbox" name="HBA1C" value="checkbox">糖化血红蛋白</td>'
        +	'<td>异常<input type="checkbox" name="abnormal14" value="checkbox"></td>'
        +	'<td></td>'
        +'</tr>'       
		+'<tr>'
        +	'<td></td>'
		+	'<td style="display:none;" onclick="ConsultClick(this);"><input type="checkbox" name="NFMK" value="checkbox">内分泌会诊</td>'
        +	'<td style="display:none;">执行<input type="checkbox" name="execute6" value="checkbox"></td>'
        +'</tr>'
 		+'<tr>'
		+	'<td>其他</td>'
        +	'<td><input type="checkbox" name="other3" value="checkbox"><input type="textbox" name="other3" value="Note"></td>'
		+	'<td style="display:none;"><input type="checkbox" name="TheRelevantDepartmentConsultation" value="checkbox">相关科室会诊</td>'
        +	'<td style="display:none;">执行<input type="checkbox" name="execute7" value="checkbox"></td>'
        +'</tr>'        
        
 		+'<tr>'
		+	'<td colspan="2" style="display:none;">麻醉</td>'
		+	'<td style="display:none;" onclick="ConsultClick(this);"><input type="checkbox" name="MZK" value="checkbox">麻醉科会诊</td>'
        +	'<td style="display:none;">执行<input type="checkbox" name="execute8" value="checkbox"></td>'
        +'</tr>'
  		+'<tr>'
		+	'<td colspan="2" style="display:none;">ICU</td>'
		+	'<td style="display:none;" onclick="ConsultClick(this);"><input type="checkbox" name="ZZYXK" value="checkbox">ICU 会诊</td>'
        +	'<td style="display:none;">执行<input type="checkbox" name="execute9" value="checkbox"></td>'
        +'</tr>'*/
        +'</table>'
    });
    if (session['LOGON.CTLOCID']=="46")
	{
		var pnlSignBC=new Ext.Panel({
	    id:'pnlSignBC',
		layout:'form',
		frame:true,
        items:[
        ]
        ,html:'<table width="100%" height=30 border="1" cellpadding="2" cellspacing="0">'
        +'<tr>'
        +	'<td width="50%">住院医师签字及日期</td><td>主管教授签字及日期</td>'
        +'</tr>'        
        +'</table>'
    	});
	}   
  	var pnlSignBC=new Ext.Panel({
	    id:'pnlSignBC',
		layout:'form',
		frame:true,
        items:[
        ]
        ,html:'<table width="100%" height=30 border="1" cellpadding="2" cellspacing="0">'
        +'<tr>'
        +	'<td width="50%">住院医师签字及日期</td><td>主管教授签字及日期</td>'
        +'</tr>'        
        +'</table>'
    });       
    var pnlRiskB=new Ext.Panel({
	    id:'pnlRiskB',
		frame:true,
        items:[
        	pnlRiskBDetail
        ]
    });
    var pnlSignC=new Ext.Panel({
	    id:'pnlSignC',
		layout:'form',
		frame:true,
        items:[
        ]
        ,html:'<table width="100%" height=30 border="1" cellpadding="2" cellspacing="0">'
        +'<tr>'
        +	'<td width="50%">教授/副教授签字及日期</td><td>科主任签字及日期</td>'
        +'</tr>'        
        +'</table>'
    });
	/*var DisplayCheck=_DHCANRRisk.LoadANRCheck("D",DisplayLocId);
    var DisplayListD=DisplayCheck.split(String.fromCharCode(1));
    //alert(DisplayListD)	
   	var AGC=""
   	if (DisplayListD!="")
   	{
   	var DisplayArrD=new Array();   	
   	LoadDisplayItemB(DisplayArrD,DisplayListD);
   	for(i=0;i<DisplayArrD.length;i++)
	{
		//alert(DisplayArrB[i]);
		if(typeof(DisplayArrD[i])!='undefined')
		{
			AGC=AGC+'<tr>'
			for(j=0;j<DisplayArrD[i].length;j++)
			{				
				if (j!=0)
				{
					if(typeof(DisplayArrD[i][j])=='undefined')
					{						
						AGC=AGC+'<td></td>'						
					}
					else AGC=AGC+DisplayArrD[i][j];
				}
				else if(typeof(DisplayArrD[i][j])!='undefined'){AGC=AGC+DisplayArrD[i][j]};
			}
			AGC=AGC+'</tr>'			
		}
		else
		{
			AGC=AGC+'<tr><td></td></tr>'
		}		
	}
   	}
   	//alert(AGC);
	var pnlRiskDDetail=new Ext.Panel({
	    id:'pnlRiskDDetail',
		layout:'form',
		//frame:true,
		//height:200,
        items:[
        ]
        ,html:'<table width="100%" border="1" cellpadding="2" cellspacing="0">'
        + AGC
        //+'<tr>'
        //+	'<td width="50%"><input type="checkbox" name="ManyConsultations" value="checkbox">多科会诊</td>'
        //+	'<td><input type="checkbox" name="MedicalDepartmentForTheRecord" value="checkbox">医务处备案</td>'
        //+'</tr>'     
        +'</table>'
    });  
	*/
    
    var pnlRiskD=new Ext.Panel({
	    id:'pnlRiskD',
		frame:true,
        items:[
        	//pnlRiskDDetail
        ]

    });
	/*var DisplayCheck=_DHCANRRisk.LoadANRCheck("E",DisplayLocId);
    var DisplayListE=DisplayCheck.split(String.fromCharCode(1));	
   	var AGC=""
   	if (DisplayListE!="")
   	{
   	var DisplayArrE=new Array();
   	LoadDisplayItemB(DisplayArrE,DisplayListE);
   	for(i=0;i<DisplayArrE.length;i++)
	{
		//alert(DisplayArrB[i]);
		if(typeof(DisplayArrE[i])!='undefined')
		{
			AGC=AGC+'<tr>'
			for(j=0;j<DisplayArrE[i].length;j++)
			{				
				if (j!=0)
				{
					if(typeof(DisplayArrE[i][j])=='undefined')
					{						
						AGC=AGC+'<td></td>'						
					}
					else AGC=AGC+DisplayArrE[i][j];
				}
				else if(typeof(DisplayArrE[i][j])!='undefined'){AGC=AGC+DisplayArrE[i][j]};
			}
			AGC=AGC+'</tr>'			
		}
		else
		{
			AGC=AGC+'<tr><td></td></tr>'
		}		
	}
	//alert(AGC);
   	}
	var pnlRiskEDetail=new Ext.Panel({
	    id:'pnlRiskEDetail',
		layout:'form',
		//frame:true,
		//height:200,
        items:[
        ]
        ,html:'<table width="100%" border="1" cellpadding="2" cellspacing="0">'
        +AGC
        //+'<tr>'
        //+	'<td width="50%"><input type="checkbox" name="LawyersConversationSignatureNotarized" value="checkbox">律师公证谈话签字</td>'
        //+	'<td><input type="checkbox" name="TheOperationOfInsurance" value="checkbox">手术保险</td>'
        //+'</tr>'   
        +'</table>'
    });  
    */
    var pnlRiskE=new Ext.Panel({
	    id:'pnlRiskE',
		frame:true,
        items:[
        	//pnlRiskEDetail
        ]

    });


	var pnlSignDE=new Ext.Panel({
	    id:'pnlSignDE',
		layout:'form',
		//frame:true,
        items:[
        ]
        ,html:'<table width="100%" height=30 border="1" cellpadding="2" cellspacing="0">'
        +'<tr>'
        +	'<td width="50%">住院医师签字及日期</td><td>科主任签字及日期</td>'
        +'</tr>'        
        +'</table>'
    });
    
    if (session['LOGON.CTLOCID']=="46")  //眼科
    { 
    	var pnlDetail=new Ext.Panel({
		id:'pnlDetail',
		//frame:true,
		columnWidth:.90,
        title:AnrcmcCode+'级风险管理',
        layout:'form',
        items: [
	        pnlRiskA
	        ,pnlRiskB	        
	        //,pnlRiskD
	       // ,pnlRiskE
	       	,pnlSignC
	        //,pnlSignBC
			//,pnlSignDE			
        ]		
		});
    }
    else
    {
	    var pnlDetail=new Ext.Panel({
		id:'pnlDetail',
		//frame:true,
		columnWidth:.90,
        title:AnrcmcCode+'级风险管理',
        layout:'form',
        items: [
	        pnlRiskA
	        ,pnlRiskB
	        ,pnlSignBC
	        //,pnlRiskD
	        //,pnlRiskE
			,pnlSignDE
        ]		
		});
    }  
	//---------------------------检验检查结果------------------------------------------- 
    var btnTest=new Ext.Button({
		id:'btnTest',
		text:'检验 '+ '<br/>' +'检查' + '<br/>' +'会诊结果',
		height:window.screen.availHeight,
		width:100,
		tooltip:"提示信息：可以查看检验  检查  会诊结果",	
		handler: function() {
        	btnResult_click("Test");
    	}
	});
    var pnlRiskResultDetail=new Ext.Panel({
	    id:'pnlRiskResultDetail',
		layout:'form',
		title:'参考',
		//frame:true,
		width:100,
        items:[
           btnTest
        ]
        /*,html:'<table width="100%" border="1" cellpadding="2" cellspacing="0">'
        +'<tr><th>获取结果</th></tr>'
        +	'<td id="Result"></td>'
        //+	'<td><input type="textbox" code="Result" anrcType="Gain"></td>'
        +'</tr>'*/
    });
    var pnlRiskResult=new Ext.Panel({
	    id:'pnlRiskResult',
		//frame:true,
		layout:'form',
		columnWidth:.10,
        items:[
        	pnlRiskResultDetail
        ]

    });
    var pnlALLDetail=new Ext.Panel({
		id:'pnlALLDetail',
        layout:'column',
        items: [
	        pnlDetail
	        ,pnlRiskResult	  
        ]		
	});


    var btnSubmit=new Ext.Button({
		id:'btnSubmit',
		text:'提交',
		handler: function() {
        	btnSubmit_click();
    	}
	});
	var btnCheck=new Ext.Button({
		id:'btnCheck',
		text:'核查',
		hidden:true,
		handler: function() {
        	btnCheck_click();
    	}
	});
	var btnAudit=new Ext.Button({
		id:'btnAudit',
		text:'审批',
		hidden:true,
		handler: function() {
        	btnAudit_click();
    	}
	});
	var btnUnAudit=new Ext.Button({
		id:'btnUnAudit',
		text:'撤销审批',
		hidden:true,
		handler: function() {
        	btnUnAudit_click();
    	}
	});
	var btnPrint=new Ext.Button({
		id:'btnPrint',
		text:'打印',
		hidden:true,
		handler: function() {
        	btnPrint_click();
    	}
	});
    var pnlButton=new Ext.Panel({
		id:'pnlButton',
		buttons:[
			btnSubmit,
			btnCheck,
			btnAudit,
			btnUnAudit,
			btnPrint
		]
	});




    var pnlTitle=new Ext.Panel({
		id:'pnlTitle',
		frame:true,
        title:'择期/限期手术风险管理项目表',
        width:1100,
        layout:'form',
        items: [
	        pnlALLDetail
	        ,pnlButton

        ],
        renderTo: bd		
	});	
	
	//-------------------data-------------------------------------------
	var valueArr=new Array();
	var codeArr=new Array();
	var valueArrB=new Array();
	var codeArrB=new Array();
	var _DHCANRRisk=ExtTool.StaticServerObject('web.DHCANRRisk');
	var ANRRStat=_DHCANRRisk.GetANRRStatus(AnrrId);	
	//alert(ANRRStat);
	var ItemDetail=new Array();
	LoadBody();
	LoadButton();
	LoadRiskItem();
	
	function LoadButton()
	{
		//审核权限
		//权限按钮 btnAudit  btnUnAudit	
		var ret=_DHCANRRisk.CheckApproval(UserId,AnrcmcDr);
		if(ret==0)
		{
			btnAudit.show();  //审批
			btnUnAudit.show();  //撤销审批
		}
		//普通按钮
		//状态控制按钮显示
		//I,S,C,A,U,D,F    Initial,Assess,Check,Audit,UnAudit,Delete,Finish
		if(ANRRStat=="S")
		{
			btnCheck.show();
			btnAudit.show();
			btnAudit.hide();
			btnUnAudit.hide();
		}		
		if(ANRRStat=="C")
		{
			btnSubmit.hide();
			btnCheck.show();
			btnUnAudit.hide();
		}
		if(ANRRStat=="A")
		{
			btnCheck.hide();
			btnSubmit.hide();
		}
		if(ANRRStat=="U")
		{
			//btnCheck.show();
			btnSubmit.show();
			//btnAudit.hide();
			btnUnAudit.hide();
		}
	}
	
	function LoadBody()
	{
		if(AnrcmcCode=="A"){
				pnlRiskB.hide();
				//pnlSignBC.hide();
				//pnlRiskD.hide();
				//pnlRiskE.hide();
				pnlSignBC.hide();
				pnlSignDE.hide();
				pnlSignC.hide();
		}
		else setPnlRiskDetail('pnlRiskBDetail');
		if (session['LOGON.CTLOCID']=="33") //各科室根据评估级别判断显示内容 胸外科
		{
			pnlSignDE.hide();
		}
		else if (session['LOGON.CTLOCID']=="31") //骨科
		{
			if (AnrcmcCode=="B"){pnlRiskB.hide();pnlSignBC.hide();pnlSignDE.hide();}
			else if (AnrcmcCode=="C"){pnlSignDE.hide();}
			else {pnlSignBC.hide();}	
		}
		else if (session['LOGON.CTLOCID']=="46") //眼科
		{
			if ((AnrcmcCode=="A")||(AnrcmcCode=="B"))			
			{
				pnlRiskB.hide();
				pnlSignC.hide();				
			}
		}				
		else
		{			
			if ((AnrcmcCode=="B")||(AnrcmcCode=="C"))
			{
				pnlSignDE.hide();
			}
			if ((AnrcmcCode=="D")||(AnrcmcCode=="E"))
			{
				pnlSignBC.hide();
			}
		}
		/*if(AnrcmcCode=="B"){
			//pnlRiskD.hide();
			//pnlRiskE.hide();
			//pnlSignA.hide();
			//pnlSignDE.hide();
			setPnlRiskDetail('pnlRiskBDetail');
		}	
		if(AnrcmcCode=="C")
		{			
			setPnlRiskDetail('pnlRiskBDetail');
		}
		if(AnrcmcCode=="D")
		{			
			setPnlRiskDetail('pnlRiskBDetail');
			//setPnlRiskDetail('pnlRiskDDetail');
		}
		if(AnrcmcCode=="E")
		{			
			setPnlRiskDetail('pnlRiskBDetail');
			//setPnlRiskDetail('pnlRiskDDetail');
			//setPnlRiskDetail('pnlRiskEDetail');
		}*/
		/*if(AnrcmcCode=="C"||AnrcmcCode=="D"||AnrcmcCode=="E")
		{
			if(AnrcmcCode=="C")
			{
				pnlRiskD.hide();
				pnlRiskE.hide();
				//pnlSignA.hide();
				pnlSignBC.show();
				pnlSignDE.hide();
			}
			if(AnrcmcCode=="D"){
				if (session['LOGON.CTLOCID']=="33")  //胸外科
				{
					pnlRiskD.hide();
					pnlRiskE.hide();
					pnlSignDE.hide();
				}
				else{pnlRiskE.hide();}
				//pnlSignA.hide();
				//pnlSignBC.hide();
			}
			if(AnrcmcCode=="E"){
				//pnlSignA.hide();
				//pnlSignBC.hide();
				if (session['LOGON.CTLOCID']=="33")  //胸外科
				{
					pnlRiskD.hide();
					//pnlRiskE.hide();
					pnlSignDE.hide();
				}
			}
		}*/		
	}
	function setPnlRiskDetail(pnlRiskDetail)
	{
		var tabObj=Ext.getCmp(pnlRiskDetail).body.dom;
		//alert(Ext.getCmp('pnlRiskBDetail').body.dom.innerHTML)		
		var arrTd=tabObj.getElementsByTagName("Td");		
		for(var i=0;i<arrTd.length;i++)
		{
			if ((arrTd[i].id=="B")&&(AnrcmcCode=="B"))
			{
				if(arrTd[i].style.display=="none")
				{
					arrTd[i].style.display="block";
				}
			}
			if (((arrTd[i].id=="B")||(arrTd[i].id=="C"))&&(AnrcmcCode=="C"))
			{
				if(arrTd[i].style.display=="none")
				{
					arrTd[i].style.display="block";
				}
			}
			if (((arrTd[i].id=="B")||(arrTd[i].id=="C")||(arrTd[i].id=="D"))&&(AnrcmcCode=="D"))
			{
				if(arrTd[i].style.display=="none")
				{
					arrTd[i].style.display="block";
				}
			}
			if (((arrTd[i].id=="B")||(arrTd[i].id=="C")||(arrTd[i].id=="D")||(arrTd[i].id=="E"))&&(AnrcmcCode=="E"))
			{
				if(arrTd[i].style.display=="none")
				{
					arrTd[i].style.display="block";
				}
			}
			/*if (session['LOGON.CTLOCID']=="33")
			{
				if (AnrcmcCode=="C")
				{
					if (arrTd[i].id!="D")
					{
						if(arrTd[i].style.display=="none")
						{
							arrTd[i].style.display="block";
						}
					}
				}
				if ((AnrcmcCode=="D")||(AnrcmcCode=="E"))
				{					
					if(arrTd[i].style.display=="none")
					{
						arrTd[i].style.display="block";
					}
				
				}				
			}
			else
			{
				if(arrTd[i].style.display=="none")
				{
					arrTd[i].style.display="block";
				}
			}*/						
		}
	}
	Array.prototype.lastIndexOf=function(item){
		        var len=this.length;       
		         for(var i=len;i>=0;i--){ 
		                        if(this[i]===item){ 
		                                               return len-i;  
		                        }
		          }
	} 
	function LoadRiskItem()
	{
		
		var ret=_DHCANRRisk.LoadRiskItem(AnrrId);
		var ArrItem=ret.split(String.fromCharCode(1));
		//alert(ArrItem);
		for(var k=0;k<ArrItem.length;k++)
		{
			var Code=ArrItem[k].split("^")[0];
			var Checked=ArrItem[k].split("^")[1];
			var Result=ArrItem[k].split("^")[2];
			var Note=ArrItem[k].split("^")[3];
			ItemDetail[Code]=new Array();
			if (Checked!="") ItemDetail[Code]["Checked"]=Checked;
			if (Result!="")ItemDetail[Code]["Result"]=Result;
			if (Note!="")ItemDetail[Code]["Note"]=Note;				
		}
		var tabObj=Ext.getCmp('pnlRiskADetail').body.dom;
		var arrTable=tabObj.getElementsByTagName("input");
		for(var i=0;i<arrTable.length;i++)
		{
			var code=arrTable[i].code;
			var anrcType=arrTable[i].anrcType;
			if(arrTable[i].anrcType=="Checked")
			{
				if (ItemDetail[code])
				{
				if(ItemDetail[code]["Checked"]=="Y") arrTable[i].checked=true;
				else arrTable[i].checked=false;
				}
			}
			if(arrTable[i].anrcType=="Result")
			{
				if(ItemDetail[code]["Result"]=="1") arrTable[i].checked=true;
				else arrTable[i].checked=false;
			}			
			if(anrcType=="Note")
			{
				if (typeof(ItemDetail[code]["Note"])!='undefined') arrTable[i].value=ItemDetail[code]["Note"]
				else arrTable[i].value=""
			}			
		}
		//B级手术风险获取数据 add mfc 20140317
		var tabObj=Ext.getCmp('pnlRiskBDetail').body.dom;
		var arrTable=tabObj.getElementsByTagName("input");
		//alert(Ext.getCmp('pnlRiskBDetail').body.dom.innerHTML)
		for(var i=0;i<arrTable.length;i++)
		{
			var code=arrTable[i].name;
			var anrcType=arrTable[i].anrcType;
			if(anrcType=="Checked")
			{
				if((ItemDetail[code])&&(ItemDetail[code]["Checked"]=="Y")) arrTable[i].checked=true;
				else arrTable[i].checked=false;
			}						
			if(anrcType=="Note")
			{
				if (typeof(ItemDetail[code]["Note"])!='undefined') arrTable[i].value=ItemDetail[code]["Note"]
				else arrTable[i].value=""
			}						
		}		
	}	
	//---------------------button function----------------------------------------
	
	function GetElementData(objTb)
	{
		var result=""
		if(objTb.type=="checkbox")
		{
			result=objTb.checked;
		}
		if(objTb.type=="text")
		{
			result=objTb.value;
		}
		return result;
	}	
		                                                             
	function btnSubmit_click()
	{
		//alert("开始");
		var remark=0		
		var tabObjA=Ext.getCmp('pnlRiskADetail').body.dom;
		//alert(tabObjA)
		var arrTable=tabObjA.getElementsByTagName("input");
		//alert(tabObj.innerHTML);		
		for(var i=0;i<arrTable.length;i++)
		{
			var code=arrTable[i].code;
			var anrcType=arrTable[i].anrcType;						
			if((typeof(code)!='undefined')&&(typeof(anrcType)!='undefined'))
			{				
				if(codeArr.indexOf(code)>-1)
				{									
					valueArr[code][anrcType]=GetElementData(arrTable[i]);
				}
				else
				{						
					codeArr.push(code);					
					valueArr[code]=new Array();
					valueArr[code][anrcType]=GetElementData(arrTable[i])
			
				}
			}		
		}				
		for(var j=0;j<codeArr.length;j++)
		{
			var valueChecked="",valueResult="",valueNote=""
			if(typeof(valueArr[codeArr[j]]["Checked"])!='undefined')
			{
				valueChecked=valueArr[codeArr[j]]["Checked"];
			}
			if(typeof(valueArr[codeArr[j]]["Result"])!='undefined')
			{
				valueResult=valueArr[codeArr[j]]["Result"];
			}
			if(typeof(valueArr[codeArr[j]]["Note"])!='undefined')
			{
				valueNote=valueArr[codeArr[j]]["Note"];
			}
			//alert(AnrrId);			
			//if (codeArr[j]=="ALT"){alert(codeArr[j]+"--"+valueChecked+"--"+valueResult+"--"+valueNote);}
			var ret=_DHCANRRisk.SaveANRCheck(AnrrId,codeArr[j],valueChecked,valueResult,valueNote);
			if(ret.split("||")[0]<0)		 	
			{
				alert("A级保存错误："+codeArr[j]+"--"+valueChecked+"--"+valueResult+"--"+valueNote);
			 	remark=-1;
		 	}
			
		}		
		//B级以上保存 add mfc 20140317
		var tabObjB=Ext.getCmp('pnlRiskBDetail').body.dom;		
		//alert(Ext.getCmp('pnlRiskBDetail').body.dom.innerHTML)		
		var arrTable=tabObjB.getElementsByTagName("input");
		for(var i=0;i<arrTable.length;i++)
		{
			var code=arrTable[i].name;
			var anrcType=arrTable[i].anrcType;				
			if((typeof(code)!='undefined')&&(typeof(anrcType)!='undefined'))
			{				
				if(codeArrB.indexOf(code)>-1)
				{									
					valueArrB[code][anrcType]=GetElementData(arrTable[i]);
				}
				else
				{						
					codeArrB.push(code);					
					valueArrB[code]=new Array();
					valueArrB[code][anrcType]=GetElementData(arrTable[i])
			
				}
			}		
		}				
		for(var j=0;j<codeArrB.length;j++)
		{
			//if (codeArrB[j]=="") {continue;};
			//alert(valueArrB[j]);
			var valueChecked="",valueResult="",valueNote=""
			if(typeof(valueArrB[codeArrB[j]]["Checked"])!='undefined')
			{
				valueChecked=valueArrB[codeArrB[j]]["Checked"];
			}
			if(typeof(valueArrB[codeArrB[j]]["Note"])!='undefined')
			{
				valueNote=valueArrB[codeArrB[j]]["Note"];
			}				
			//alert(codeArrB[j]+"--"+valueChecked+"--"+valueResult+"--"+valueNote);
			//if (valueNote!="") {codeArrB[j]};		
			var ret=_DHCANRRisk.SaveANRCheck(AnrrId,codeArrB[j],valueChecked,"",valueNote);
			//if (codeArrB[j]=="CRFdecompensated"){alert(codeArrB[j]+"--"+valueChecked+"--"+valueNote);}
			//alert(ret.split("||")[0]);
			if(ret.split("||")[0]<0)		 
		 	{
			 	alert("B级保存错误："+codeArrB[j]+"--"+valueChecked+"--"+valueNote);
			 	remark=-1;
		 	}
		
		}							
		//改变状态  提交"S" 审核"C"
		if(remark==0)
		{	
		    //alert("提交成功！");
		    //alert(ANRRStat);		
			var res=_DHCANRRisk.SetANRRStatus(AnrrId,ANRRStat);
			if(res!=0) alert(res);
			//window.close();			
			var lnk="dhcanrqueryrisk.csp?";
			window.open(lnk,'_self',"");	
		}
	}
	function btnCheck_click()
	{
		if(ANRRStat=="S"||ANRRStat=="C") ANRRStat="C";
		btnSubmit_click();
	}
	function btnAudit_click()
	{
		var res=_DHCANRRisk.SetANRRStatus(AnrrId,"A");
		if(res!=0) alert(res);
		else alert("审批成功!");
	}
	function btnUnAudit_click()
	{
		var res=_DHCANRRisk.SetANRRStatus(AnrrId,"U");
		if(res!=0) alert(res);
		else alert("撤销审批成功!");
	}
	function btnPrint_click()
	{
		alert("待开发……")
	}
   
    function  btnResult_click(value)
	{
		switch (value)
		{
		  case 'Test':
		  		var lnk= "dhcanrcriskresult.csp?"
				var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=0,left=0"
	   			lnk+="Regno="+Regno+"&EpisodeID="+AmdId;
	   			window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=800,width=1100,top=10,left=30");		
				break;
		  
		}
	}
});