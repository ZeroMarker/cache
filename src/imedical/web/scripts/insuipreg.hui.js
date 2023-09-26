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
 var InsuType=""
 var AdmDr="" 
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
	 
	//#9 住院登记界面调转本界面处理
    RegLinkIni();
});

//初始化医保类型
function InitInsuTypeCmb()
{
    var options = {
		   hospDr:HospDr,
		   defaultFlag:"N"
		}
	INSULoadDicData("InsuType","DLLType",options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#InsuType",{
	    	onSelect:function(rec)
	    	{
		    	InsuType=rec.cCode;
		    	InitYLLBCmb();         //医疗类别
		    	InitInsuDiagCmbGd(); //诊断
		    	//QryInsuDiag();         //诊断
		    	InitBCFSCmb();       //治疗方式
		    	InitZLFSCmb();       //补偿方式
		    }
		});
}

//初始化元素事件
function InitBtnClick(){
	//登记号回车事件
	$("#PapmiNo").keydown(function(e) 
	  { 
	     PapmiNo_onkeydown(e);
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
	
    $("#CardNo").bind('click onmouseenter',
      function(e){
	     var CardNo=getValueById('CardNo');
	     setValueById('OldCardNo',CardNo)
	    }); 
	}	
	
	
//登记号回车函数	
function PapmiNo_onkeydown(e){	
	if (e.keyCode==13)
	{
		AdmDr=""
		AdmReasonDr=""
		AdmReasonNationalCode=""
		Clear(0);
		GetPatInfo(); 
    }		
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
	var TempString="",InsuAdmType="",CardInfo="",InsuNo=""
	var StDate="",EndDate=""
	var obj=$('#btnReg').linkbutton("options")
	if (obj.disabled==true){return ;}
	
	//医保类型
	var InsuType=$('#InsuType').combobox('getValue');
    if (InsuType==""){
	    $.messager.alert("提示","请选择医保类型!", 'info');
		return ;
    }
    
    //医疗类别
    InsuAdmType=$('#InsuAdmType').combobox('getValue');
    if (InsuAdmType==""){
	    $.messager.alert("提示","请选择医疗类别!", 'info');
		return ;
    }
    
    //医保号/医疗证号
	InsuNo=getValueById('InsuNo');
	
	//医保入院诊断编码
    var InsuInDiagCode=getValueById('InsuInDiagCode');  
                
	//医保入院诊断名称
    var InsuInDiagDesc=$('#InsuInDiagDesc').combogrid('getValue') 
    
	//就诊日期
	var AdmDate=getValueById('AdmDate'); 
	
	 //就诊时间
	var AdmTime=getValueById('AdmTime');
	
	//治疗方式
	var ZLFSStr=$('#ZLFS').combobox('getValue');	
	
	//补偿方式
	var BCFSStr=$('#BCFS').combobox('getValue')	

	TempString=InsuAdmType+"^"+InsuInDiagCode+"^"+InsuInDiagDesc+"^"+InsuNo+"^"+AdmDate+"^"+AdmTime+"^"+ZLFSStr+"^"+BCFSStr+"^"+InsuType
	
	//医保登记
	var flag=InsuIPReg(0,GUser,AdmDr,AdmReasonNationalCode, AdmReasonDr,TempString)//DHCInsuPort.js
	if (flag!="0") 
	 {
		$.messager.alert("提示","医保登记失败!rtn="+flag, 'error');
		return ;
	}
	$.messager.alert("提示","医保登记成功!", 'info');
	UpdatePatAdmReason(AdmDr,"",GUser)
    GetPatInfo();
	
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
	 var OldCardNo=getValueById('OldCardNo');
	 if (NewCardNo==OldCardNo){		   
  	  	$.messager.alert("提示","修改的医保卡号没变化，请重新填写!", 'info');
   	 	return;   
	 }
  
	var flag=tkMakeServerCall("web.INSUAdmInfoCtlCom","UpdateINSUCardNo",AdmDr,OldCardNo+"_"+NewCardNo);
	if(flag=="0")
	{
	  setValueById('CardNo',NewCardNo);
	  setValueById('OldCardNo',OldCardNo);
	  OldCardNo=NewCardNo; //更新成功后，新的卡号变成就卡号了
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
	 	 $.messager.alert('提示','取基本信息失败,请输入正确的登记号!','error' ,function(){
		 	  return ;
		 	 });
 	}else
 	{
	 	aData=rtn.split("^");
	 	setValueById('Name',aData[2]);             //姓名
	 	setValueById('Sex',aData[4]);              //性别
	 	setValueById('Age',aData[3]);              //年龄
	 	setValueById('PatID',aData[8]);            //身份证号
	 	setValueById('CTProvinceName',aData[16]);  //省
	 	setValueById('CTCityName',aData[18]);      //市
	 	setValueById('CTAreaName',aData[20]);      //区
	 	setValueById('BDDT',aData[9]);             //出生日期
	 	setValueById('MedicareNo',aData[14]);       //住院号
	    //CTProvinceCode=aData[15];
        //CTCityCode=aData[17];
        //CTAreaCode=aData[19];
         //InitAdmCmbGd();
         //InitAdmDiagCmbGd();
         QryAdmLst();
         QryDiagLst();
	 	return ;
	 }
	return ;
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
			  setValueById('AdmDate',rowData.AdmDate)
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
		},
		
		onLoadSuccess:function(data)
		{
	
			if (data.total==0)
			{
				$.messager.alert("提示", "没有查询到病人就诊记录,请先确认患者是否护士分床!", 'info');
				return ;
				
			}
			var indexed=-1
			var Flag=0
			for(var i in data.rows)
			{
				if(data.rows[i].VisitStatus=="在院")
				{
					indexed=i;
					Flag=1
				}
				if (Flag==0)
				{
					indexed=i;
					
				}
				if(AdmDr==data.rows[i].AdmDr)
				{
					indexed=i;
				}
		    }
		    
		    if (indexed>=0)
		    {
			    var rowData=data.rows[indexed]
					$('#AdmLst').combogrid("setValue",rowData.AdmNo+"-"+rowData.DepDesc+"-"+rowData.AdmDate+" "+rowData.AdmTime+"-"+rowData.VisitStatus+"-"+rowData.AdmReasonDesc)
				    setValueById('DepDesc',rowData.DepDesc)
			        setValueById('AdmDate',rowData.AdmDate)
			        setValueById('AdmTime',rowData.AdmTime)
			        setValueById('InDiagCode',rowData.InDiagCode)
			        setValueById('InDiagDesc',rowData.InDiagDesc)
			        setValueById('AdmReasonDesc',rowData.AdmReasonDesc)
				    AdmDr=rowData.AdmDr
				    AdmReasonDr=rowData.AdmReasonDr
			        AdmReasonNationalCode=rowData.ReaNationalCode
			        //InitAdmDiagCmbGd();
			        QryDiagLst();
			        GetInsuAdmInfo();
			        QryInAdmInfo()
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
	        {field:'DiagnosDesc',title:'诊断名称',width:160}, 
	        {field:'DiagnosMRDesc',title:'诊断注释',width:80},   
	        {field:'DiagnosType',title:'诊断类型',width:80},   
	        {field:'DiagStat',title:'诊断状态',width:80},   
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
{
	var tURL=$URL+"?ClassName="+'web.DHCINSUPortUse'+"&MethodName="+"GetPatAllDiagsByADM"+"&PAADM="+AdmDr+"&DiagType="+""+"&ExpStr="+("^"+InsuType+"^HUIToJson")
    $('#DiagLst').combogrid({url:tURL});
   
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
		} else {
			var myAry = rtn.split("!")[1].split("^");
			var actDesc = "";
			if (myAry[11] == "A") {
				actDesc = "在院";
			   disableById("btnReg");
				enableById("btnRegCancle");
			}
			if (myAry[11] == "O") {
				actDesc = "出院";
				disableById("btnReg");
				disableById("btnRegCancle");
			}
			if (myAry[11] == "S") {
				actDesc = "取消登记";
				enableById("btnReg");
				disableById("btnRegCancle");
			}
			setValueById("InsuActiveFlag", actDesc);           //医保登记状态
			setValueById("InsuNo", myAry[2]);               //医保号
			setValueById("CardNo", myAry[3]);               //医保卡号
			setValueById("NewCardNo", myAry[3]);            //新医保卡号
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
			setValueById("xzlx",myAry[37])                   //险种类型
	        setValueById("dylb",myAry[36])                   //待遇类别
	        setValueById("AdmDate",myAry[12])                //入院日期
	        setValueById("AdmTime",myAry[13])                //入院时间
            setValueById("InsuAdmSeriNo",myAry[10])          //医保就诊号
            setValueById("InsuCenter",myAry[8])              //医保统筹区
			//setValueById("ZLFS", myAry[38]);               //治疗方式
			//setValueById("BCFS", myAry[39]);               //补偿方式
		}
	});
	
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
				return ;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length > 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
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

//加载医保诊断(支持检索)
function InitInsuDiag(){
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
				return ;
				}
			if (getValueById("InsuType") && ($.trim(param.q).length > 1)) {
				$("#InsuInDiagDesc").combogrid("grid").datagrid("options").url = $URL;
				param.ClassName = "web.DHCINSUIPReg";
				param.QueryName = "GetInsuDiagnosis";
				param.InsuInDiagDesc = param.q;
				param.InsuType = getValueById("InsuType");
				param.HospDr=HospDr;
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
			height:560,
			width:985,
		    iconCls:'icon-w-paper',
			modal:true
			
		})
	
		
	}
	
	
//赋值医保就诊弹窗元素		
function FillInAdmDl(Data)
{
	
	setValueById('FXString6',Data.TXString6);     //姓名
	setValueById('FXString5',Data.TXString5);     //身份证号
	setValueById('FXString7',Data.TXString7);     //性别
	setValueById('FInsuId',Data.TInsuId);       //医保个人编号
	setValueById('FCardNo',Data.TCardNo);       //医保卡号
	setValueById('FCardStatus',Data.TCardStatus);   //医保卡状态
	setValueById('FAdmType',Data.TAdmType);      //就诊类型
	setValueById('FPatType',Data.TPatType);      //人员类型
	setValueById('FAdmSeriNo',Data.TAdmSeriNo);    //医保就诊号
	setValueById('FActiveFlag',Data.TActiveFlag);    //登记状态
	setValueById('AdmDate',Data.TAdmDate);      //入院日期
	setValueById('FAdmTime',Data.TAdmTime);      //入院时间
	setValueById('FInsuUser',Data.TInsuUser);     //入院操作员
	setValueById('FFunDate',Data.TFunDate);      //登记发生日期
	setValueById('FFunTime',Data.TFunTime);      //登记发生时间
	setValueById('FXString7',Data.TXString7);     //待遇类型
	setValueById('FOutUser',Data.TOutUser);      //出院操作员
	setValueById('FOutDate',Data.TOutDate);      //出院日期
	setValueById('FOutTime',Data.TOutTime);      //出院时间
	setValueById('FDeptDesc',Data.TDeptDesc);     //就诊科室
	setValueById('FCompany',Data.TCompany);      //单位名称
	setValueById('FStates',Data.TStates);       //地区
	setValueById('FCenter',Data.TCenter);       //统筹区
	setValueById('FXString1',Data.TXString1);     //医保入院诊断编码
	setValueById('FXString2',Data.TXString2);     //医保入院诊断名称
	setValueById('FIpTimes',Data.TIpTimes);      //住院次数
	setValueById('FAdmCancelNo',Data.TAdmCancelNo);  //冲销流水号
	setValueById('FXString3',Data.TXString3);     //医保出院诊断编码
	setValueById('FXString4',Data.TXString4);     //医保出院诊断描述
	setValueById('FXString9',Data.TXString9);     //预留9
	setValueById('FXString10',Data.TXString10);    //预留10
	setValueById('FXFloat1',Data.TXFloat1);      //预留1
	setValueById('FXFloat2',Data.TXFloat2);      //预留2
	setValueById('FXFloat3',Data.TXFloat3);      //预留3
	setValueById('XFloat4',Data.TXFloat4);       //预留4
	setValueById('FXString11',Data.TXString11);    //预留11
	setValueById('FXString12',Data.TXString12);    //预留12
	setValueById('FXString13',Data.TXString13);    //预留13
	setValueById('FXString14',Data.TXString14);    //预留14
	setValueById('FXString15',Data.TXString15);    //预留15
	setValueById('FXString16',Data.TXString16);    //预留16
	setValueById('FXString17',Data.TXString17);    //预留17
	setValueById('FXString18',Data.TXString18);    //预留18
	setValueById('FXString19',Data.TXString19);    //预留19
	setValueById('FXString20',Data.TXString20);    //预留20

	
}		
	
//清空医保就诊弹窗元素	
function ClearInAdmDl()
{
	
	getValueById('FXString7',"");     //姓名
	getValueById('FXString5',"");     //身份证号
	getValueById('FXString6',"");     //性别
	getValueById('FInsuId',"");       //医保个人编号
	getValueById('FCardNo',"");       //医保卡号
	getValueById('FCardStatus',"");   //医保卡状态
	getValueById('FAdmType',"");      //就诊类型
	getValueById('FPatType',"");      //人员类型
	getValueById('FAdmSeriNo',"");    //医保就诊号
	getValueById('FActiveFlag',"");    //登记状态
	getValueById('FAdmDate',"");      //入院日期
	getValueById('FAdmTime',"");      //入院时间
	getValueById('FInsuUser',"");     //入院操作员
	getValueById('FFunDate',"");      //登记发生日期
	getValueById('FFunTime',"");      //登记发生时间
	getValueById('FXString7',"");     //待遇类型
	getValueById('FOutUser',"");      //出院操作员
	getValueById('FOutDate',"");      //出院日期
	getValueById('FOutTime',"");      //出院时间
	getValueById('FDeptDesc',"");     //就诊科室
	getValueById('FCompany',"");      //单位名称
	getValueById('FStates',"");       //地区
	getValueById('FCenter',"");       //统筹区
	getValueById('FXString1',"");     //医保入院诊断编码
	getValueById('FXString2',"");     //医保入院诊断名称
	getValueById('FIpTimes',"");      //住院次数
	getValueById('FAdmCancelNo',"");  //冲销流水号
	getValueById('FXString3',"");     //医保出院诊断编码
	getValueById('FXString4',"");     //医保出院诊断描述
	getValueById('FXString9',"");     //预留9
	getValueById('FXString10',"");    //预留10
	getValueById('FXFloat1',"");      //预留1
	getValueById('FXFloat2',"");      //预留2
	getValueById('FXFloat3',"");      //预留3
	getValueById('XFloat4',"");       //预留4
	getValueById('FXString11',"");    //预留11
	getValueById('FXString12',"");    //预留12
	getValueById('FXString13',"");    //预留13
	getValueById('FXString14',"");    //预留14
	getValueById('FXString15',"");    //预留15
	getValueById('FXString16',"");    //预留16
	getValueById('FXString17',"");    //预留17
	getValueById('FXString18',"");    //预留18
	getValueById('FXString19',"");    //预留19
	getValueById('FXString20',"");    //预留20
}	

function InitDiagsQry()
{
	$("#InsuInDiagDesc").searchbox({
		prompt: '请输入关键字',
        searcher: function (value, name) {
                initDiagFrm(value);
            } 
	});
}

function InitDiagDg(KeyWords){
	
     //alert("KeyWords="+KeyWords+"InsuType="+InsuType)
	 //初始化datagrid
	$HUI.datagrid("#indiagdg",{
		rownumbers:true,
	    width:445,
	    height:260,
		//striped:true,
		//fitColumns:true,
		singleSelect: true,
		//autoRowHeight:false,
		data: [],
		columns:[[
		
			{field:'Rowid',title:'Rowid',width:60},
			{field:'Code',title:'医保诊断编码',width:120},
			{field:'Desc',title:'医保诊断名称',width:230}
			//{field:'TStDate',title:'生效日期',width:140},
			//{field:'TEndDate',title:'截止日期',width:140}	
		]],
		url:$URL+"?ClassName=web.DHCINSUIPReg&QueryName=GetInsuDiagnosis&InsuInDiagDesc="+encodeURI(KeyWords)+"&InsuType="+InsuType+"&HospDr="+HospDr,
		pageSize: 5,
		pageList:[5,10],
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	    
            
        },
        onDblClickRow:function(rowIndex, rowData){
	       
	        $('#InsuInDiagDesc').searchbox('setValue', rowData.Desc);
	        setValueById('InsuInDiagCode',rowData.Code)
	        $('#DiagDlBd').window('close');  
	        },
        onUnselect: function(rowIndex, rowData) {
        }
	});
	 
}
		
//初始化医疗类别
function InitYLLBCmb()
{
	var options = {
		   hospDr:HospDr,
		   defaultFlag:"Y",
		   DicOPIPFlag:"IP"
		}
	INSULoadDicData("InsuAdmType",("AKA130"+InsuType),options); // dhcinsu/common/dhcinsu.common.js
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

//初始化不放方式
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
		rownumbers:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'操作',
		    formatter: function (value, row, index) {
							return "<img class='myTooltip' style='width:60' title='详细信息' onclick=\"InAdmFrmClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/pat_info.png' style='border:0px;cursor:pointer'>";
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
			{field:'TAdmDate',title:'入院日期',width:100},
			{field:'TAdmTime',title:'入院时间',width:80},
			{field:'TInsuUser',title:'入院登记人',width:100},
			{field:'TFunDate',title:'入院登记日期',width:120},
			{field:'TFunTime',title:'入院登记时间',width:120},
			{field:'TOutUser',title:'出院登记人',width:140},
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
		if(rtn!=0){$.messager.alert("提示","医保登记成功,但是更新费别失败,rtn="+rtn, 'info')}
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
	setValueById('AdmDate',"");
	setValueById('AdmTime',"");
	setValueById('DepDesc',"");
	setValueById('InDiagCode',"");
	setValueById('InDiagDesc',"");
	setValueById('AdmReasonDesc',"");
	//$('#AdmLst').combogrid('setValue',"")
	//$('#DiagLst').combogrid('setValue', "")
    $('#AdmLst').combogrid('clear');
    $('#DiagLst').combogrid('clear');
    setValueById('AdmLst','');
    setValueById('DiagLst','');
    $('#AdmLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
    $('#DiagLst').combogrid('grid').datagrid("loadData",{total:-1,rows:[]});
   
	}
function ClearInsuAdmInfo() {
	$('#InsuType').combobox('setValue',"");
    $('#InsuAdmType').combobox('setValue',"");
	$('#InsuInDiagDesc').combogrid('setValue',"");
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
	