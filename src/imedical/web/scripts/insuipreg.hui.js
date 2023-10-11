/**
 * 医保住院登记JS
 * FileName:insuipreg.hui.js
 * DingSH 2019-04-22
 * 版本：V1.0 
 * hisui版本:0.1.0
 */
 var AdmReasonDr="",AdmReasonNationalCode=""
 var HospDr=session['LOGON.HOSPID'];
 var GUser=session['LOGON.USERID'];
 var InsuType="";
 var AdmDr="";
 var InsuCurCardNo=""; //当前医保卡号
 var MedTypeDicRelationFlag=""; // 20220829 医疗类别关联字典标志
 var InsuRegRepFlag="Y"; // 20230525 医保重复登记标志
 $(function()
 {
    $(document).keydown(function (e) {
	             banBackSpace(e);
	         }); 	       
	         
	//#1 初始化医保类型	
	InitInsuTypeCmb();
	
	//#2 初始化医疗类别
	InitYLLBCmb();
	
	//#3 初始化医保诊断
	InitInsuDiagCmbGd();
	 //InitInsuDiag();

    //#4 初始化就诊记录
    InitAdmLst();
    
    //#5 初始化就诊诊断记录
	InitDiagLst();
	
	//#6 初始化Btn事件
	InitBtnClick(); 
	
	//#7 初始化医保就诊记录
	 InitInAdmDg();
	
	//#8 隐藏元素
	$('#InAdmDlg').hide();
	 
    //#9 医保配置控制
    InitPROConfg();
    
    //#0 住院登记界面调转本界面处理
    RegLinkIni();        
	
	//st add 20220919 HanZH
	//#11 初始化病种
	InitDiseNameCmbGd();
	
	//#12 初始化手术操作
	InitOprnOprtNameCmbGd();
	//ed
});


//医保配置控制,医保配置在这里增加
function InitPROConfg()
{
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetSys",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		InString: "HISPROPerty"+InsuType,
		HospDr: HospDr
	}, function (rtn) {
        if (typeof rtn != "string")
         {
	       return ;
	     }
	     var DicAry = rtn.split("!")
	     for(var i =1,len=DicAry.length;i<len;i++)
	     {
		     var DataAry = DicAry[i].split("^");
		     var DicCode = DataAry[2];
		     var DicVal = DataAry[3];
		     switch (DicCode)
		     { 
		              /*医保配置在这里增加*/
	             case "AdmDateIsEdit" :
	                    var RdFlag='enable'
	                    //if (DicVal == 0){
	    	              // RdFlag='disable'
	                     //}
	                     //$("#AdmDate").datebox(RdFlag);
	                     //$("#AdmTime").timespinner(RdFlag);   //-注释掉 DingSH 20220919
	                      enableById('AdmDate')  // 修改 DingSH 20220919 
	                      enableById('AdmTime')
	                      if (DicVal == 0){
	    	                disableById('AdmDate')
	                        disableById('AdmTime')
	                     }
	                    
	    	          break;
	    	     
	             default :
	    	          break;
	           }
		 }
		
	});

}
//初始化医保类型
function InitInsuTypeCmb()
{
    var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y"
		}
	INSULoadDicData("InsuType","DLLType",options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#InsuType",{
	    	onSelect:function(rec)
	    	{
		    	InsuType=rec.cCode;
		    	InitYLLBCmb();           //医疗类别
		    	InitInsuDiagCmbGd();     //诊断
		    	//QryInsuDiag();         //诊断
		    	InitZLFSCmb();           //治疗方式
		    	InitBCFSCmb();           //补偿方式
		    	InitMdtrtCertTypeCmb();  //就医凭据类型
		    	InitPROConfg();          //医保配置控制
		    	//add 20220919 HanZH
				InitDiseNameCmbGd();	 //病种
				InitOprnOprtNameCmbGd(); //手术操作
				InitadmdvsCmbGd();		 //医保区划  +20230330 HanZH
		    }
		});
}

//初始化元素事件
function InitBtnClick(){
	//登记号回车事件
	$("#PapmiNo").keydown(function(e) 
	  { 
	    if (e.keyCode==13)
	    {
	      PapmiNo_onkeydown();
	    }
	   });  
	//住院号回车事件
	$("#MedicareNo").keydown(function(e) 
	  { 
	     MedicareNo_onkeydown(e);
	   });  
	 $("#CardNo").change(function(){ 
         var CardNo=getValueById('CardNo');
	     setValueById('NewCardNo',CardNo)
     });
	
   /* $("#CardNo").bind('click onmouseenter',
      function(e){
	     var CardNo=getValueById('CardNo');
	     setValueById('OldCardNo',CardNo)
	    }); */
	}	
	
	
//登记号回车函数	
function PapmiNo_onkeydown(){	
	//if (e.keyCode==13)
	//{
		AdmDr=""
		AdmReasonDr=""
		AdmReasonNationalCode=""
		Clear(0);
		GetPatInfo(); 
    //}		
}

//住院号回车函数	
function MedicareNo_onkeydown(e){	
	if (e.keyCode==13)
	{
		
		 var PatNo=""
         PatNo=tkMakeServerCall("web.DHCINSUIPReg","GetPatNoByMrNo",getValueById('MedicareNo'),"I",HospDr);
	     if (PatNo!="") {
		         AdmDr=""
		         AdmReasonDr=""
		         AdmReasonNationalCode=""
		         Clear(0);
		         setValueById('PapmiNo',PatNo)
		         GetPatInfo(); 
		      
		   }
		
     }		
}
//医保登记函数		        
function InsuIPReg_onclick(){

	//校验是否医保登记
	var _validReg = function(){
	       return new Promise(function(resolve,reject){
		       var obj=$('#btnReg').linkbutton("options")
	           if (obj.disabled==true){return reject();}
		       	//医保类型
	           var InsuType=$('#InsuType').combobox('getValue');
               if (InsuType ==""){
	             $.messager.alert("提示","请选择医保类型!", 'info');
		         return reject();
                }
              //医疗类别
               InsuAdmType=$('#InsuAdmType').combobox('getValue');
              if (InsuAdmType==""){
	           $.messager.alert("提示","请选择医疗类别!", 'info');
		        return reject();
               }
		       resolve();
		       });
	 }
	 
	//生育患者 弹窗护理组更新生育信息界面
   	var _MantRegFlag=function(){
	       return new Promise(function(resolve,reject){
		      //+ WangXQ 20220829 生育类别患者弹窗
             if(MedTypeDicRelationFlag=="1"){
	             var url = "nur.hisui.medfertilityinfo.csp?EpisodeID="+AdmDr;
	 	         websys_showModal({
		         url: url,
		         title: "生育信息填写",
		         iconCls: "icon-w-edit",
		         width: "855",
		         height: "400",
		         onClose: function () {
			          MedTypeDicRelationFlag="";
	  			}
		        })
               }
                resolve();
               });
		 
	}
	
 //医保登记函数	
 var _InsuReg=function(){
   return new Promise(function(resolve,reject){
	   	     var TempString="",InsuType="",InsuAdmType="",CardInfo="",InsuNo=""
	         var StDate="",EndDate=""
	         //获取医保类型
	         var InsuType=$('#InsuType').combobox('getValue');
	         
	         //获取就诊类别
	         InsuAdmType=$('#InsuAdmType').combobox('getValue');
	         
			//医保号/医疗证号
			InsuNo=getValueById('InsuNo');
			
			//医保入院诊断编码
		    var InsuInDiagCode=getValueById('InsuInDiagCode');  
		                
			//医保入院诊断名称
		    var InsuInDiagDesc=$('#InsuInDiagDesc').combogrid('getText');
		    
			//就诊日期
			var AdmDate=getValueById('AdmDate'); 
			
			 //就诊时间
			var AdmTime=getValueById('AdmTime');
			
			//治疗方式
			var ZLFSStr=$('#ZLFS').combobox('getValue');	
			
			//补偿方式
			var BCFSStr=$('#BCFS').combobox('getValue')	

			//就诊凭证类型
			var mdtrtCertType=getValueById('mdtrt_cert_type');	
			
			//就诊凭证编号
			var mdtrtCertNo=getValueById('mdtrt_cert_no')	
			
			//参保地医保区划
			//var insuplcAdmdvs=getValueById('insuplc_admdvs')
			//upt HanZH 20230410
			var insuplcAdmdvs=$('#insuplc_admdvs').combogrid('getValue')
		
			//add 20220919 HanZH
			//病种编码
			var diseCodg=getValueById('diseCodg');
			//病种名称
			var diseName=getValueById('diseName');
			//手术操作代码
			var oprnOprtCode=getValueById('oprnOprtCode');
			//手术操作名称
			var oprnOprtName=getValueById('oprnOprtName');
			//upt 20230328 HanZH 界面选择病种为空时再判断是否允许不选病种进行医保登记的医疗类别的配置
			if (diseCodg=="") {
				//增加配置 允许不选病种进行医保登记的医疗类别	20220920 HanZH
				var RegFlag=""
				var RegFlagStr=tkMakeServerCall("web.INSUDicDataCom","GetDicByCodeAndInd","HISPROPerty"+InsuType,"AlwNoDiseSelRegOfMedType",4,HospDr);
				if (RegFlagStr!=""){
					if(RegFlagStr.indexOf("|"+InsuAdmType+"|")!=-1){
						RegFlag="Y";
					}
				}
				if(RegFlag!="Y"){
					$.messager.alert("提示","请选择医疗类别="+InsuAdmType+"的病种信息!", 'info');
					return ;
				}
			}
			var JSSSLB="",psnCardType="",psnCardno="";
			//TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType+"^"+""+"^"+mdtrtCertType+"^^"+JSSSLB+"^"+mdtrtCertNo+"^"+psnCardType+"^"+psnCardno+"^"+insuplcAdmdvs
			TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType+"^"+""+"^"+mdtrtCertType+"^^"+JSSSLB+"^"+mdtrtCertNo+"^"+psnCardType+"^"+psnCardno+"^"+insuplcAdmdvs+"^"+diseCodg+"^"+diseName+"^"+oprnOprtCode+"^"+oprnOprtName
			
			//医保登记
			var flag=InsuIPReg(0,GUser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
			InsuRegRepFlag="N";
			if (flag == 0) 
			{
				$.messager.alert("提示","医保登记成功!", 'info');
			}
			else	
			 {
				$.messager.alert("提示","医保登记失败!rtn="+flag, 'error');
				return reject() ;
			}
			 UpdatePatAdmReason(AdmDr,"",GUser);
			//GetPatInfo();
			 PapmiNo_onkeydown();
	         resolve();
	  });
	}
   var promise = Promise.resolve();
	promise
		.then(_validReg)
		.then(_MantRegFlag)
		.then(_InsuReg, function () {
			//reject()
		});
   
}
//取消医保登记
function InsuIPRegCancel_onclick(){
	var obj=$('#btnRegCancle').linkbutton("options")
	if (obj.disabled==true){return ;}
	if(""==AdmDr)
	{	
	 $.messager.alert("提示","请选择病人及就诊信息!", 'info');
	 return;
	}
	//就诊凭证类型	电子凭证医保登记数据取消医保登记让操作员选择确认	20220916 HanZH
	var mdtrtCertType=getValueById('mdtrt_cert_type');
	if (mdtrtCertType=="01"){
		var oldOk = $.messager.defaults.ok;
		var oldCancel = $.messager.defaults.cancel;
		$.messager.defaults.ok = "确定";
		$.messager.defaults.cancel = "取消";
		$.messager.confirm("取消医保登记", "电子凭证医保登记数据，是否确定取消医保登记", function (r) {
			if (r) {
				//登记取消
				var ExpStr="^^^"
				var flag=InsuIPRegStrike(0,GUser,AdmDr, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
				if (+flag<0) {
					 $.messager.alert("提示","取消登记失败!"+flag, 'error');
					 return;
					}
				 $.messager.alert("提示","取消登记成功!", 'info');
				 //InitAdmCmbGd();
				 GetPatInfo();
			}else{
				$.messager.popover({ msg: "操作取消" });
				return;
			}
		});
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel; 
	}else
	{
		//登记取消
		var ExpStr="^^^"
		var flag=InsuIPRegStrike(0,GUser,AdmDr, AdmReasonNationalCode, AdmReasonDr,ExpStr) //DHCInsuPort.js
		if (+flag<0) {
			 $.messager.alert("提示","取消登记失败!"+flag, 'error');
			 return;
			}
		 $.messager.alert("提示","取消登记成功!", 'info');
		 //InitAdmCmbGd();
		 GetPatInfo();
	}
}

//医保登记函数
function InsuReadCard_onclick() {
	
	//医保类型
	var InsuType=$('#InsuType').combobox('getValue');
    if (InsuType==""){
	    $.messager.alert("提示","请选择医保类型!", 'info');
		return ;
    }
	//医保号/医疗证号
	InsuNo=getValueById('InsuNo');
	//医保卡类型
	var CardType="" ;
	//扩展串
	var ExpString=InsuType+"^^^"
	var flag=InsuReadCard(0,GUser,InsuNo,CardType,ExpString);//DHCInsuPort.js
	var NewCardNo="",CardNo="";
	if (eval(flag.split("|")[0])==0)
	{
		$.messager.alert("提示","读医保卡成功!", 'info');
		//医保卡返回参数格式：参考医保读卡返回固定参数列表V2.0.xls
		 var InsuCardStr=flag.split("|")[1];
		 NewCardNo=InsuCardStr.split("^")[1];
		 setValueById('NewCardNo',NewCardNo);
	}
	CardNo=getValueById('CardNo');
	setValueById('OldCardNo',CardNo);
	if ((NewCardNo!="")&&(CardNo!="")&&(CardNo!=NewCardNo))
	{
	$.messager.confirm('确认',"读医保卡的卡号："+NewCardNo+",和登记时医保卡号："+CardNo+"不一致，是否进行修改？",function(r){    
    if (r){    
       UpdINSUCardNo_onclick();   
    }    
    });  
   }
	
	
}
	
	
 //更新医保卡卡号
 function UpdINSUCardNo_onclick(){

	var NewCardNo=getValueById('NewCardNo');
 	if ((NewCardNo=="")||((NewCardNo==" "))){		   
  	  	$.messager.alert("提示","修改的医保卡号为空，请填写!", 'info');
   	 	return;   
	 }
	 //var OldCardNo=getValueById('OldCardNo');
	 if (NewCardNo==InsuCurCardNo){		   
  	  	$.messager.alert("提示","修改的医保卡号没变化，请重新填写!", 'info');
   	 	return;   
	 }
	var flag=tkMakeServerCall("web.INSUAdmInfoCtlCom","UpdateINSUCardNo",AdmDr,InsuCurCardNo+"_"+NewCardNo);
	if(flag=="0")
	{
	  setValueById('CardNo',NewCardNo);
	  setValueById('OldCardNo',InsuCurCardNo);
	  //OldCardNo=NewCardNo; //更新成功后，新的卡号变成就卡号了
	  GetPatInfo();
	  $.messager.alert("提示","更新医保卡号信息成功!", 'info');
	}
	else
	{
	  $.messager.alert("提示","更新医保卡号信息失败!", 'error');
		
	}
	 
	}	
	
	
///获取病人基本信息函数
function GetPatInfo(){	
    var tmpPapmiNo=$('#PapmiNo').val()
	if (tmpPapmiNo=="")
		{
		$.messager.alert("提示","登记号不能为空!", 'info');
		return ;
		}
	 var PapmiNoLength=10-tmpPapmiNo.length;     //登记号补零   	

		for (var i=0;i<PapmiNoLength;i++){
			tmpPapmiNo="0"+tmpPapmiNo;			
		}
	
   PapmiNo=tmpPapmiNo;	
   setValueById('PapmiNo',PapmiNo)              //登记号补全后回写
   var rtn=""
    rtn=tkMakeServerCall("web.DHCINSUIPReg","GetPatInfoByPatNo","","",PapmiNo,HospDr);
    if (typeof rtn != "string")
    {
	    return ;
	}
   if (rtn.split("!")[0]!="1") {
	 	 setTimeout(function(){$.messager.alert('提示','取基本信息失败,请输入正确的登记号!','error')},200);
		 return ;
 	}
 	else
 	{
	 	aData=rtn.split("^");
	 	setValueById('Name',aData[2]);             //姓名
	 	setValueById('Sex',aData[4]);              //性别
	 	setValueById('Age',aData[3]);              //年龄
	 	setValueById('PatID',aData[8]);            //身份证号
	 	setValueById('CTProvinceName',aData[16]);  //省
	 	setValueById('CTCityName',aData[18]);      //市
	 	setValueById('CTAreaName',aData[20]);      //区
	 	//setValueById('BDDT',aData[9]);             //出生日期
	 	setValueById('MedicareNo',aData[14]);       //住院号
	    //CTProvinceCode=aData[15];
        //CTCityCode=aData[17];
        //CTAreaCode=aData[19];
         //InitAdmCmbGd();
         //InitAdmDiagCmbGd();
         QryAdmLst();
         QryDiagLst();
		setValueById('BDDT',GetInsuDateFormat(aData[9],3))	//出生日期	upt HanZH 20220805
	 }
}	

//初始化就诊记录函数
function InitAdmLst()
{
	$('#AdmLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'AdmDr',  
	    textField:'AdmNo' ,  
	    columns:[[    
	        {field:'AdmDr',title:'AdmDr',width:60},    
	        {field:'AdmNo',title:'就诊号',width:120}, 
	        {field:'DepDesc',title:'就诊科室',width:160},   
	        {field:'AdmDate',title:'就诊日期',width:100},   
	        {field:'AdmTime',title:'就诊时间',width:100},   
	        {field:'VisitStatus',title:'就诊状态',width:120},  
	        //{field:'AdmReasonDr',title:'就诊费别',width:120},      
	        {field:'AdmReasonDesc',title:'就诊费别',width:120},      
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var AdmLstVal=rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc
		      $('#AdmLst').combogrid("setValue",AdmLstVal)
			  setValueById('DepDesc',rowData.DepDesc)
			  //setValueById('AdmDate',rowData.AdmDate)
			  setValueById('AdmTime',rowData.AdmTime)
			  setValueById('InDiagCode',rowData.InDiagCode)
			  setValueById('InDiagDesc',rowData.InDiagDesc)
			  setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
			  AdmDr=rowData.AdmDr
			  AdmReasonDr=rowData.AdmReasonDr
			  AdmReasonNationalCode=rowData.ReaNationalCode
			  //InitAdmDiagCmbGd()
			  QryDiagLst();
			  GetInsuAdmInfo()
			  QryInAdmInfo()

			  AdmDate=GetInsuDateFormat(rowData.AdmDate,3)
			  setValueById('AdmDate',AdmDate)	//入院日期	upt HanZH 20220805
		},
		
		onLoadSuccess:function(data)
		{
	        if (data.total<0) 
	        {
		        disableById("btnReg");        //+ 20220831
		        disableById("btnRegCancle");  
		        disableById("btnAppyReg");  //+ upt 20230314 Jins1010
		        return ;
	        }
			if (data.total==0)
			{
				disableById("btnReg");        //+ 20220831 
		        disableById("btnRegCancle");  
		        disableById("btnAppyReg");  //+ upt 20230314 Jins1010
				$.messager.alert("提示", "没有查询到病人就诊记录,请先确认患者是否护士分床!", 'info');
				return ;
			}
			else 
			{
			  var indexed=-1
			  var Flag=0
			  for(var i in data.rows)
			  {
				if( data.rows.hasOwnProperty(i)){
					if(AdmDr==data.rows[i].AdmDr)
					{
						indexed=i;
						 Flag=1;
						 break;
					}
					if((data.rows[i].VisitStatus=="在院")&&(AdmDr==""))
					  {
						indexed=i;
						 Flag=1;
						 break;
					  }
				}
				// if (Flag==0)
				//   {
				// 	indexed=i;
				//  	break;
				//   }
				// if(AdmDr==data.rows[i].AdmDr)
				// {
				// 	indexed=i;
				//  	break;
				// }
				indexed=0;
		      }
		    
		      if (indexed>=0)
		       {
			    var rowData=data.rows[indexed]
					$('#AdmLst').combogrid("setValue",rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc)
				    setValueById('DepDesc',rowData.DepDesc)
			        //setValueById('AdmDate',rowData.AdmDate)
			  		
			        setValueById('AdmTime',rowData.AdmTime)
			        setValueById('InDiagCode',rowData.InDiagCode)
			        setValueById('InDiagDesc',rowData.InDiagDesc)
			        setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
				    AdmDr=rowData.AdmDr
				    AdmReasonDr=rowData.AdmReasonDr
			        AdmReasonNationalCode=rowData.ReaNationalCode
			        //InitAdmDiagCmbGd();
			       
			        GetInsuAdmInfo();
			        QryInAdmInfo();
			        QryDiagLst();
			        
					AdmDate=GetInsuDateFormat(rowData.AdmDate,3)
					setValueById('AdmDate',AdmDate)	//入院日期	upt HanZH 20220805
			 }
		    }
		    
		}
       
});  
	
}

//查询就诊记录函数
function QryAdmLst()
{
	var tURL=$URL+"?ClassName="+'web.DHCINSUIPReg'+"&MethodName="+"GetPaAdmListByPatNoIPReg"+"&PapmiNo="+getValueById('PapmiNo')+"&itmjs="+"HUIToJson"+"&itmjsex="+""+"&HospDr="+HospDr
    $('#AdmLst').combogrid({url:tURL});
}


///初始化就诊诊断记录函数
function InitDiagLst()
{
	
	$('#DiagLst').combogrid({    
	    panelWidth:780, 
	    method:'GET',
	    idField:'DiagnosICDCode',  
	    textField:'DiagnosDesc' ,  
	    columns:[[    
	        {field:'DiagnosICDCode',title:'诊断编码',width:100},   
	        {field:'DiagnosPrefix',title:'诊断前缀',width:80},  
	        {field:'DiagnosDesc',title:'诊断名称',width:160}, 
	        {field:'DiagnosMRDesc',title:'诊断注释',width:80},  
	         {field:'MainDiagFlag',title:'主诊断',width:60,align:'center',
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "是":"否" 
			        }
			   },    
	        {field:'DiagnosType',title:'诊断类型',width:80,align:'center'},   
	        {field:'DiagStat',title:'诊断状态',width:80,align:'center'},   
	        {field:'InsuDiagCode',title:'医保诊断编码',width:110},  
	        {field:'InsuDiagDesc',title:'医保诊断描述',width:150}      
	    ]] ,
		onClickRow:function(rowIndex, rowData)
		{
			  var DiagLstVal=rowData.DiagnosICDCode+"-"+rowData.DiagnosDesc+"-"+rowData.DiagnosMRDesc+"-"+rowData.DiagStat+"-"+rowData.InsuDiagCode+"-"+rowData.InsuDiagDesc
		      $('#DiagLst').combogrid("setValue",DiagLstVal)
			  setValueById('InDiagCode',rowData.DiagnosICDCode)
			  setValueById('InDiagDesc',rowData.DiagnosDesc)
		},
       
  });  

}
///查询就诊诊断记录函数
function QryDiagLst()
{   if (!!AdmDr)
    {
	 var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+AdmDr+"&DiagType="+""+"&ExpStr="+("^"+InsuType+"^HUIToJson")
     $('#DiagLst').combogrid({url:tURL});
    }
   
}


//获取医保就诊信息函数
function GetInsuAdmInfo()
{

	$.m({
		ClassName: "web.DHCINSUIPReg",
		MethodName: "GetInfoByAdm",
		type: "GET",
		itmjs: "",
		itmjsex: "",
		Paadm: AdmDr
	}, function (rtn) {
          if (typeof rtn != "string")
         {
	       return ;
	     }
		if (rtn.split("!")[0] != "1") {
			enableById("btnReg");
			enableById("btnRegCancle");
			enableById("btnAppyReg"); //+20230314 JinS1010
			if (rtn=="-100"){
				ClearInsuAdmInfo();	//+20221125 HanZH
				//初始化医保类型 +20230317 HanZH		
				InitInsuTypeCmb();
				InitYLLBCmb();
			}
		} else {
			var myAry = rtn.split("!")[1].split("^");
			if (((myAry[11] == "A") || (myAry[11] == "O")) && (InsuRegRepFlag=="Y")){
				var oldOk = $.messager.defaults.ok;
				var oldNo = $.messager.defaults.no;
				$.messager.defaults.ok = " 是 ";
				$.messager.defaults.no = " 否 ";
				var btcnfm = $.messager.confirm("温馨提醒", "已存在有效登记信息，是否再次登记?", function (r) {
					if (r) {
				        InitInsuTypeCmb();
				        InitYLLBCmb();
				        enableById("btnReg");
						enableById("btnRegCancle");
						enableById("btnAppyReg"); //+20230314 JinS1010
						return;
					} else {
						_loadInsuAdmInfo(myAry);
					}
					/*要写在回调方法内,否则在旧版下可能不能回调方法*/
					$.messager.defaults.ok = oldOk;
					$.messager.defaults.no = oldNo;
				}).children("div.messager-button");
				btcnfm.children("a:eq(1)").focus();
				btcnfm.children("a:eq(0)").addClass('green'); 
			}else{
				InsuRegRepFlag="Y";
				_loadInsuAdmInfo(myAry);
			}
			
		}
	});
    //加载医保登记信息 + 20230411 DingSH
	function _loadInsuAdmInfo (myAry) {

		var actDesc = "";
		if (myAry[11] == "A") {
			actDesc = "在院";
			disableById("btnReg");
			enableById("btnRegCancle");
			disableById("btnAppyReg"); //+20230314 JinS1010
		}
		if (myAry[11] == "O") {
			actDesc = "出院";
			disableById("btnReg");
			disableById("btnRegCancle");
			disableById("btnAppyReg"); //+20230314 JinS1010
		}
		if (myAry[11] == "S") {
			actDesc = "取消登记";
			enableById("btnReg");
			disableById("btnRegCancle");
			enableById("btnAppyReg"); //+20230314 JinS1010
		}
		setValueById("InsuActiveFlag", actDesc);        //医保登记状态
		setValueById("InsuNo", myAry[2]);               //医保号
		setValueById("CardNo", myAry[3]);               //医保卡号
		//setValueById("NewCardNo", myAry[3]);          //新医保卡号
		InsuCurCardNo= myAry[3];                         
		setValueById("OldCardNo", myAry[39]);           //旧医保卡号
		InsuType=myAry[18];			
		setValueById("InsuType",myAry[18])
		InitYLLBCmb(myAry[14]);                          //医疗类别
		InitBCFSCmb();                                  //治疗方式
		InitZLFSCmb();                                   //补偿方式
		setValueById("InsuPatType", myAry[4]);          //人员类别
		$("#InsuInDiagDesc").combogrid("grid").datagrid("loadData", {
			total: 1,
			rows: [{"Code": myAry[26], "Desc": myAry[27]}]
		});
		$("#InsuInDiagDesc").combogrid("setValue", myAry[26]);   //医保诊断
		setValueById("insuTreatType", myAry[36]);        //待遇类别
		setValueById("insuAdmSeriNo", myAry[10]);        //医保就诊号
		//setValueById("xzlx",myAry[37])                   //险种类型
		//setValueById("dylb",myAry[36])                   //待遇类别
		setValueById("xzlx",myAry[36])                   //险种类型	upt HanZH 20220929
		setValueById("dylb",myAry[37])                   //待遇类别	upt HanZH 20220929
		//setValueById("AdmDate",myAry[12])                //入院日期
		setValueById("AdmTime",myAry[13])                //入院时间
		setValueById("InsuAdmSeriNo",myAry[10])          //医保就诊号
		setValueById("InsuCenter",myAry[8])              //医保统筹区
		//setValueById("ZLFS", myAry[38]);               //治疗方式
		//setValueById("BCFS", myAry[39]);               //补偿方式
		InitMdtrtCertTypeCmb(myAry[42]);                 //就诊凭据类型
		setValueById("mdtrt_cert_no",myAry[43])          //就诊凭据编号
		InitPROConfg();                                  //医保配置控制
		AdmDate=GetInsuDateFormat(myAry[12],3)           //日期格式化
		setValueById('AdmDate',AdmDate)	                 //入院日期	upt HanZH 20220805
		
		var disOper=myAry[38].split("|")
		setValueById('diseCodg',disOper[0]); //upt HanZH 20220929
		setValueById('diseName',disOper[1]); //upt HanZH 20220929
		if(disOper.length=4){
			setValueById('oprnOprtName',disOper[2]); //upt HanZH 20220929
			setValueById('oprnOprtCode',disOper[3]); //upt HanZH 20220929
		}
		//医保统筹区	add HanZH 20230410
		$('#insuplc_admdvs').combogrid("setValue",myAry[8]);
		$('#insuplc_admdvs').combogrid("setText",myAry[54]);


	}
	
}

//查询医保就诊信息
function QryInAdmInfo()
{
 $('#inadmdg').datagrid('options').url = $URL	
 $('#inadmdg').datagrid('reload',{
	ClassName:'web.DHCINSUIPReg',
	QueryName:'GetInsuAdmInfo',
	AdmDr:AdmDr
	});
}

//加载医保诊断(支持检索)
function InitInsuDiagCmbGd(){
$("#InsuInDiagDesc").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'Code', title: '医保诊断编码', width: 120},
			 {field: 'Desc', title: '医保诊断名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
			}else{
				$('#InsuInDiagDesc').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("InsuInDiagCode", rowData.Code);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("InsuInDiagCode", "");
			}
		}
	});
}
function  QryInsuDiag()
{
	$('#InsuInDiagDesc').combogrid('clear');
	var tURL=$URL+"?ClassName="+'web.DHCINSUIPReg'+"&QueryName="+"GetInsuDiagnosis"+"&InsuInDiagDesc="+getValueById("InsuInDiagDesc")+"&InsuType="+ getValueById("InsuType")+"&HospDr="+HospDr
    $('#InsuInDiagDesc').combogrid({url:tURL});
}




//点击操作触发函数
function  InAdmFrmClick(rowIndex){
	    
	initInAdmDlFrm(rowIndex);
	
}
	
	
//医保就诊信息弹窗
function initInAdmDlFrm(rowIndex){
	
	var rowData=$('#inadmdg').datagrid("getRows")[rowIndex];    

	 $('#InAdmDlg').show(); 
	 ClearInAdmDl();
	 FillInAdmDl(rowData);
	 $HUI.dialog("#InAdmDlg",{
			title:"医保就诊信息",
			height:528,
			width:948,
		    iconCls:'icon-w-paper',
			modal:true
			
		})
	
		
	}
	
	
//赋值医保就诊弹窗元素		
function FillInAdmDl(Data)
{
	
	for (var key in Data) {
     if (Data.hasOwnProperty.call(Data, key)) {
         setValueById('F'+key.substr(1),Data[key]);
         
     }
    }

	
}		
	
//清空医保就诊弹窗元素	
function ClearInAdmDl()
{
	
	$('#InAdmDl').form('clear');
}	




		
//初始化医疗类别
function InitYLLBCmb()
{   
    MedTypeDicRelationFlag=""  //20220829  医疗类别关联字典标识
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		}
	//INSULoadDicData("InsuAdmType",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	INSULoadDicData("InsuAdmType",("med_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js	20220106
	if(arguments.length ==1)
	{
		var InsuAdmType=arguments[0] || "";
		$HUI.combobox("#InsuAdmType",{
			onLoadSuccess:function(data){
				if (InsuAdmType!="")
				{
					setValueById('InsuAdmType',InsuAdmType);
				}
			},
			onSelect:function(data){
				MedTypeDicRelationFlag=data.DicRelationFlag
			}
		});
	}
	
	
}

//初始化入院原因 +20200916 DingSH
function InitInsuIPRsCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		  
		}
	//INSULoadDicData("InsuIPRs",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	INSULoadDicData("InsuIPRs",("med_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js	upt 20220106
	
	if(arguments.length ==1)
	{
	var InsuAdmType=arguments[0];
	$HUI.combobox("#InsuAdmType",{
	      onLoadSuccess:function(data){
				       setValueById('InsuAdmType',InsuAdmType);
				     }
				});
	}
}


//初始化治疗方式
function InitZLFSCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"N",
		}
	INSULoadDicData("ZLFS",("ZLFS"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
}

//初始化补偿方式
function InitBCFSCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"N",
		}
	INSULoadDicData("BCFS",("BCFS"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
}

//初始化就诊Grid
function InitInAdmDg()
{
    //初始化datagrid
	$HUI.datagrid("#inadmdg",{
	    //url:$URL,
		border:false,	
		toolbar:[],
		data: [],
		fitColumns: false,
		rownumbers:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'操作',
		    formatter: function (value, row, index) {
						//return "<img class='myTooltip' style='width:60' title='详细信息' onclick=\"InAdmFrmClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/pat_info.png' style='border:0px;cursor:pointer'>";
						//return "<span class='myTooltip' style='color:#339EFF' onclick='InAdmFrmClick(" + row.TrnsLogDr + "," + row.Infno + ")'>详情</span>";
						return "<a class='myTooltip' style='color:#339EFF' onclick=\"InAdmFrmClick('" + index+"')\" style='border:0px;cursor:pointer'>详情</a>";
					}
		  }
		
		]],
		columns:[[
		
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TInsuId',title:'医保个人编号',width:120},
			{field:'TCardNo',title:'医保卡号',width:100},
			{field:'TPatType',title:'人员类型',width:80},
		    {field:'TAdmType',title:'就诊类型',width:80},
			{field:'TDeptDesc',title:'就诊科室',width:120},
			{field:'TActiveFlag',title:'登记状态',width:80},
			{field:'TAdmDate',title:'入院日期',width:100,align:'center'},
			{field:'TAdmTime',title:'入院时间',width:80,align:'center'},
			{field:'TInsuUser',title:'经办人',width:100},
			{field:'TFunDate',title:'经办日期',width:120,align:'center'},
			{field:'TFunTime',title:'经办时间',width:120,align:'center'},
			{field:'TOutUser',title:'出院经办人',width:140},
			{field:'TStates',title:'参保地区',width:100},
			{field:'TCenter',title:'分中心',width:80},
			{field:'TAccount',title:'医保账户',width:80},
			{field:'TAdmSeriNo',title:'医保就诊号',width:100},
			{field:'TInsuType',title:'医保类型',width:80},
			{field:'TCardStatus',title:'医保卡状态 ',width:100},
			{field:'TCompany',title:'公司名称',width:100},
			{field:'TAdmDr',title:'TAdmDr',width:60},
		]],
		pageSize: 10,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {  
        },
        onDblClickRow:function(rowIndex, rowData){
	       
	        },
        onUnselect: function(rowIndex, rowData) {
        
        }
	});
	
}

 //根据Padm.Rowid 更新费别
 //ReadId 为空时  根据 医保登记信息 中心 人员类别 更新费别
 //ReadId 不为空时 根据传入的ReadId进行更新费别
//DingSH 20160713	
function UpdatePatAdmReason(AdmDr,ReadId,ExpStr)
{
	$.m
	({
		ClassName:"web.DHCINSUIPReg",
		MethodName:"UpdatePatAdmReason",
		PAADMDr:AdmDr,
		ReaId:ReadId,
		ExpStr:ExpStr
		},
	function(rtn)
	{
		if(rtn.split("^")[0]!=0){$.messager.alert("提示","医保登记成功,但是更新费别失败,rtn="+rtn, 'info')}
	});
	
 }	
 
 function Clear(AFlag){
	ClearPatInfo(AFlag);
	ClearPaadmInfo(AFlag);
	ClearInsuAdmInfo();
}


function ClearPatInfo(AFlag) {
	setValueById('Name',"");
    setValueById('Sex',"");
	setValueById('Age',"");
	setValueById('BDDT',"");
	if(AFlag){
		setValueById('PapmiNo',"");
		setValueById('MedicareNo',"");
		$(".validatebox-text").validatebox("validate");
	}
	setValueById('PatID',"");
	setValueById('CTProvinceName',"");
	setValueById('CTCityName',"");
	setValueById('CTAreaName',"");
	}
function ClearPaadmInfo(AFlag) {
	AdmDr="";
	setValueById('AdmDate',"");
	setValueById('AdmTime',"");
	setValueById('DepDesc',"");
	setValueById('InDiagCode',"");
	setValueById('InDiagDesc',"");
	setValueById('AdmReasonDesc',"");
	//$('#AdmLst').combogrid('setValue',"")
	//$('#DiagLst').combogrid('setValue', "")
    //$('#AdmLst').combogrid('clear');
    //$('#DiagLst').combogrid('clear');
    
    $HUI.combogrid("#AdmLst").clear();
    $HUI.combogrid("#DiagLst").clear();
    $('#AdmLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
    $('#DiagLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
   
	}
function ClearInsuAdmInfo() {
	$('#InsuType').combobox('setValue',"");
    $('#InsuAdmType').combobox('setValue',"");
	$('#InsuInDiagDesc').combogrid('clear');
	$('#InsuInDiagDesc').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
	setValueById('InsuInDiagCode',"");
	setValueById('InsuPatType',"");
	setValueById('dylb',"");
	setValueById('xzlx',"");
	setValueById('InsuNo',"");
	setValueById('CardNo',"");
	setValueById('OldCardNo',"");
	setValueById('InsuCardStatus',"");
	setValueById('InsuActiveFlag',"");
	setValueById('InsuAdmSeriNo',"");
	setValueById('InsuCenter',"");
	$('#ZLFS').combobox('setValue',"");
    $('#BCFS').combobox('setValue',"");
	$("#inadmdg").datagrid("loadData",{total:0,rows:[]}); //20191028
	setValueById('mdtrt_cert_type',"");	//20220106
	setValueById('mdtrt_cert_no',""); //20220106
	
	setValueById('diseName',""); //20220929
	setValueById('diseCodg',""); //20220929
	setValueById('oprnOprtName',""); //20220929
	setValueById('oprnOprtCode',""); //20220929

	setValueById('insuplc_admdvs',""); //20230331
	
	}
	
	
///处理住院登记界面到医保界面跳转的请求参数	
function RegLinkIni() {
	if(ArgPapmiNo==undefined) return;
	AdmReasonDr=""
	AdmReasonNationalCode=""
	Clear(0);
	if(ArgAdmDr!=""){
		AdmDr=ArgAdmDr
	}
	if(ArgPapmiNo!=""){
		setValueById('PapmiNo',ArgPapmiNo)
		GetPatInfo(); 
	}
	
}	
//初始化就诊凭证类型
function InitMdtrtCertTypeCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		}
	INSULoadDicData("mdtrt_cert_type",("mdtrt_cert_type"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
	if(arguments.length ==1)
	{
	var selVal=arguments[0];
	$HUI.combobox("#mdtrt_cert_type",{
	      onLoadSuccess:function(data){
				       setValueById('mdtrt_cert_type',selVal);
				     }
				});
	}
}	
//加载病种(支持检索)
function InitDiseNameCmbGd(){
$("#diseName").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'Code', title: '病种编码', width: 120},
			 {field: 'Desc', title: '病种名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#diseName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDise";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.MedType = getValueById("InsuAdmType");
				param.HospDr=HospDr
			}else{
				$('#diseName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("diseCodg", rowData.Code);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("diseCodg", "");
			}
		}
	});
}

function InitOprnOprtNameCmbGd(){
$("#oprnOprtName").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'OprnOprtCode',
		textField: 'OprnOprtName',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
			 {field: 'OprnOprtCode', title: '手术操作代码', width: 120},
			 {field: 'OprnOprtName', title: '手术操作名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#oprnOprtName").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "QueryOPRNOPRTLISTNEW";
				param.QryType="";
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.Desc = param.q;
				param.HospId=HospDr;
				param.HiType = getValueById("InsuType");
				param.StDate="";
				param.EndDate="";
				param.Code="";
				param.HisBatch="";
				param.Ver=""
			}else{
				$('#oprnOprtName').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
				return false;
				 
				}
		},
		onSelect: function(rowIndex, rowData) {
			setValueById("oprnOprtCode", rowData.OprnOprtCode);
		},
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				setValueById("oprnOprtCode", "");
			}
		}
	});
}
//2023/03/01 JinS1010 医保住院审批申请弹窗
function btnAppyReg_onclick()  
{
	 
	var obj=$('#btnAppyReg').linkbutton("options")
	if (obj.disabled==true){return ;}
	if(""==AdmDr)
	{	
	 $.messager.alert("提示","请选择病人及就诊信息!", 'info');
	 return;
	}
	
	var url = "dhcinsu.regappy.csp?&AdmDr="+AdmDr
    websys_showModal({
		url: url,   
		title: "医保住院审批申请",
		iconCls: "icon-w-add",		
		top:"108px", 
		left:"152px",
		onClose: function () {
			
		}
	});
	
}
//医保扩展信息测试
function btnInsuAdmExt_onclick()
{
	
	if(AdmDr==""){
	
		$.messager.alert("提示","请选择就诊信息！", 'info')

		return ;
		}
	var url = "dhcinsu.admext.csp?&AdmDr="+AdmDr	
    websys_showModal({
		url: url,
		title: "医保扩展信息",
		iconCls: "icon-add",	
		width: "500",
		height: "550",	
		onClose: function () {
			
		}
	});
}

//初始化医保区划 +20230330
function InitadmdvsCmbGd(){
	$("#insuplc_admdvs").combogrid({
		panelWidth: 420,
		validType: ['checkInsuInfo'],
		delay: 300,
		mode: 'remote',
		method: 'GET',
		fitColumns: true,
		pagination: true,
		idField: 'Code',
		textField: 'Desc',
		data: [],
		columns: [
			[{field: 'Rowid', title: 'Rowid', hidden: true},
				{field: 'Code', title: '区划代码', width: 120},
				{field: 'Desc', title: '区划名称', width: 230}]
		],
		onBeforeLoad: function(param) {
			if (typeof param.q == "undefined"){
				return false;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length >= 1)) {
				$("#insuplc_admdvs").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetAdmdvs";
				param.Admdvs = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr
			}else{
				$('#insuplc_admdvs').combogrid('grid').datagrid("loadData",{total:0,rows:[]});
					return false;
			}
		},
		onClickRow:function(rowIndex, rowData)
		{
			  admdvs=rowData.Code;
		},
	});
}
