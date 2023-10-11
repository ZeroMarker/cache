<!--js  bill.einv.einvtopaper.js -->
<!-- 入口函数 -->


var UserID = session['LOGON.USERID'];
var Hospital = session['LOGON.HOSPID'];
var Group=session['LOGON.GROUPID']
var Loc=session['LOGON.CTLOCID']
/*调用博思打印接口，初始化打印组件
var jj = new BsIndustryApi ({
		'appId': 'NXYKDXZYY7954090',
		'appKey': '60128aa31681a47725ccf8bf56',
		'type': 'medical',
		'url': 'http://10.0.11.94:7001/medical-web'});



var jj = new BsIndustryApi({'appId':'CDYXYDYFSYY2256028',
    'appKey':'97a85ceaae9a5da0536c6dce7d',
    'type':'medical',
    'url':'http://172.16.50.88:7001/medical-web/'});
    
    
 var industry = new BsIndustryApi({'appId':'CDYXYDYFSYY2256028',
        'appKey':'97a85ceaae9a5da0536c6dce7d',
        'type':'medical',
        'url':'http://172.16.50.88:7001/medical-web/'});
        */

$(function(){
	setPageLayout();
	setElementEvent();
	//GetStockBillNo("");
	//FindData();	    //查询
});

function setPageLayout(){
	//电子票据上传信息查询
	SetPatInfoItem();
}
function setElementEvent(){
	//作废空白纸质票据
	$('#blankBtn').click(function(){
	     invalidBlank();
	     //altVoidInv();
	});
	//原号补打
	//$('#clsBtn').hide()
	$('#clsBtn').click(function(){
		PrintOnly();
	});
	
	//重新换开纸质票据
	$('#queryBtn').click(function(){
		reTurnPaper();
	});
	//换开纸质票据
	$('#exBtn').click(function(){
		TurnPaper();
	});
	//读卡
	$('#ReadCard').click(function(){
		
	});
	//清屏
	$('#Clear').click(function(){
		Clear();
	});
	//查询
	$('#Find').click(function(){
		//查询上传成功的电子发票信息
		FindData();
		});
		
	//add by xubaobao 2020 09 08
	//换开电子票据(先作废第三方电子票据,然后重新开电子票)
	$('#ReTurnEPaperBtn').click(function(){
		ReTurnEPaper();
	});
}

///+dongkf 2020 03 02 start
var ALLINVTypeArr=[];
var CountNum=0;           //次数


function ReloadEinvTypeCombox(){
	var AdmLogicType=$('#AdmType').combobox('getValue');
	var baseInvLen=ALLINVTypeArr.length;
	if((AdmLogicType=="")||(baseInvLen==0)){
		CountNum=CountNum+1;
		if(CountNum<3){
			setTimeout("ReloadEinvTypeCombox()","100");
		}else{
			return 0;
		}
	}else{
		var AdmInvTypeArr=[];
		var objTmp=null;
		var AdmTypeTmp="";
		var DefaultVal="";
		var DicCodeTmp="";
		var DicDemoTmp="";
		var AdmTypesTmp="";
		var AdmTypeArr="";
		for (index=0; index<ALLINVTypeArr.length; index++){
			objTmp=ALLINVTypeArr[index];
			AdmTypesTmp=objTmp.DicBill1;
			AdmTypeArr=AdmTypesTmp.split(',');
			if(AdmTypeArr.indexOf(AdmLogicType)!=-1){
			//if(objTmp.DicBill1==AdmLogicType){
				AdmInvTypeArr.push(objTmp);
				
				DicCodeTmp=objTmp.DicCode;     //字典编码
				DicDemoTmp=objTmp.DicDemo;     //备注  这里的1 代表默认值
				if(DefaultVal==""){  //默认第一个为默认选项
					DefaultVal=DicCodeTmp;
				}
				if(DicDemoTmp=="1"){  //有配置的时候 根据配置选项设置默认值
					DefaultVal=DicCodeTmp;
				}
			}
		}
		if(AdmInvTypeArr.length>0){
			$('#IUDPayAdmType').combobox('loadData', AdmInvTypeArr);   //根据 业务类型设置 票据类型下拉框
			$('#IUDPayAdmType').combobox('setValue',DefaultVal);       //设置默认选项
		}
	}
}
/// ============end================

//电子票据上传信息查询
function SetPatInfoItem(){
	//获取当前日期
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#stDate').datebox('setValue', nowDate);
	//设置结束日期值
	$('#edDate').datebox('setValue', nowDate);
	///加载就诊类型下拉框
	$HUI.combobox('#AdmType',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	    	param.ResultSetType="array";
	    	param.Type="BusinessType"          
	    }
	    ,onLoadSuccess:function(){
		    $('#AdmType').combobox('setValue','OP');
		 }
	    ,onChange:function(){
			//setIUDPayAdmType();
			//ReloadEinvTypeCombox();
			CountNum=0;
			setTimeout("ReloadEinvTypeCombox()","100");
		} 
	});
	
	
	///加载操作员下拉框 modify 2020-5-21 ZhaoZW
	$HUI.combobox('#operator',{
		panelHeight: 150,
		url: $URL,
		valueField: 'userID',
		textField: 'userName',
		mode:'remote',
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName = "BILL.EINV.BL.COM.InvPrtGrantCtl";
			param.QueryName = 'QuerySSUserInfo';
			param.ResultSetType = 'array';
			param.KeyWord=$('#operator').combobox('getValue');
	    }   
	});
	//收据类型
	$HUI.combobox('#IUDPayAdmType',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	    	param.ResultSetType="array";
	    	param.Type="LogicIUDType"          
	    }//
	    ,onLoadSuccess:function(){
			var objTmp=null;
			var rows=$('#IUDPayAdmType').combobox('getData');
			if(rows.length>ALLINVTypeArr.length){
				for(i=0; i<rows.length; i++){
					objTmp=rows[i];
					ALLINVTypeArr.push(objTmp);
				}
				$('#IUDPayAdmType').combobox('setValue','PO');
			} 
		}
	    ,onChange:function(){
			GetStockBillNo("");    //票据号码查询
		}
	});	
	
	//卡类型
	$HUI.combobox('#CardType',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	    	param.ResultSetType="array";
	    	param.Type="CardType"          
	    }
	     
	});
	$('#DataList').datagrid({
		fit:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
		singleSelect:true,
		//singleSelect:false,
		selectOnCheck:false,
		checkOnSelect:false,
		striped:true,
		rownumbers:false,
		fit:true,
		url:$URL,
		columns:[[
			{field:'ind',title:'序号'},
			{field:'checkbox',checkbox:true},
			{field:'PatNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'IUDPayAdmType',title:'就诊类型',width:50,
			formatter: function(value){
					if(value == "OP"){
						return '门诊'
					}
					if(value == "IP"){
						return '住院'	
					}
					if(value == "C"){
						return '通用'	
					}
				}
        	},
			{field:'IUDCreatAmt',title:'票据金额',width:100},
			{field:'IUDBillBatchCode',title:'票据代码',width:100},
			{field:'IUDBillBatchNo',title:'票据号码',width:100},
			//{field:'IUDBillBatchCode1',title:'纸质票据代码',width:100},
			//{field:'IUDBillBatchNo1',title:'纸质票据号码',width:100},
			{field:'USRName',title:'上传人',width:100},
			{field:'IUDDate',title:'上传日期',width:100},
			{field:'IUDTime',title:'上传日期',width:100},
			{field:'IUDVoucherBatchCode',title:'预交金票据代码',width:100,hidden:true},
			{field:'IUDVoucherNo',title:'预交金票据号码',width:100,hidden:true},
			{field:'IUDCreatDate',title:'换开日期',width:100},
			{field:'IUDPrintType',title:'票据模式',width:80},
			{field:'RateStatus',title:'纸质生成状态',width:100},
			{field:'IUDInvDr',title:'发票表ID',width:100},
			{field:'IUDInitRowID',title:'原发票表ID',width:100},
			{field:'IUDBillisScarlet',title:'是否已开红票 ',width:100},
			{field:'IUDBillBatchStatus',title:'电子票据状态 ',width:100}
		]],
		onBeforeLoad:function(param){
			param.rows='20';
		}
	});
}		
///作废空白纸质票据	
function invalidBlank()
{
	var receiptType=$('#AdmType').combobox('getValue');
	var voucherType=$('#IUDPayAdmType').combobox('getValue');
	//window.location.href="bill.einv.validblankpaper.csp"
	
	//调用HIs收费界面跳号界面
	window.open ("bill.einv.validblankpaper.csp", "newwindow", "height=400, width=620, top=200, left=400, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no")
	
	/*
	var iHeight = 400;
	var iWidth = 620;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2;  //获得窗口的水平位置
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=bill.einv.validblankpaper.csp&CurrentInsType=" + voucherType + "&receiptType=" + receiptType;
   	websys_createWindow(lnk, '_blank', "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top="+iTop+",left="+iLeft+",width="+iWidth+",height="+iHeight);
	*/
	//altVoidInv();	
	GetStockBillNo("");		//add by xubaobao 2020 08 13 更新票号
}

///读卡
function ReadCard(){}



function FindData()
{
	var IUDStDate = $('#stDate').datebox('getValue');
	var IUDEdDate = $('#edDate').datebox('getValue');
	var AdmType= $('#AdmType').combobox('getValue')
	var InvNO=$('#IUDPrtNo').val();
	var UserID=$('#operator').combobox('getValue');
	var RegNo=$('#rmarkNo').val();
	var queryParam={
		ClassName:'BILL.EINV.BL.COM.InvPageInfoCtl',
		QueryName:'QueryBillIUDInfo',
        IUDStDate:IUDStDate,
		IUDEdDate:IUDEdDate,
		IUDAdmType:AdmType,
		InvNo:InvNO,
		UserId:UserID,
		RegNo:RegNo
	}
	$('#DataList').datagrid({
		url:$URL,
		queryParams:queryParam
	})	
	$('#DataList').datagrid('load')
	}

// 原号打印
function PrintOnly(){
	var rows = $('#DataList').datagrid('getChecked');
	if (rows.length !=1) {
		$.messager.alert("提示","请选择一行数据！");
		return;
	}
	
	if(rows[0].PrintType =="E"){
		$.messager.alert("提示","电子票据不能原号打印！");
		return;
	}
	
	var pBillBatchCode=rows[0].IUDBillBatchCode;
	var pBillNo= rows[0].IUDBillBatchNo;
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("提示","票据代码、票据号码不能为空!");
		return;
	}
	
	var PayAdmType=rows[0].IUDPayAdmType;
	PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //调用博思打印
	
}

///换开纸质票据
function TurnPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("提示","换开纸质票据时,票号代码与当前可用票号不能为空.");
		return;
	}
	var ErrInfo=$('#ErrMsgInfo').text()
	if(ErrInfo=="第三方当前票号获取失败"){
		$.messager.alert("提示","换开纸质票据时,第三方当前票号获取失败.");
		return;
	}
	
	if(parseInt(ErrInfo)>parseInt(pBillNo)){
		$.messager.alert("提示","换开纸质票据时,第三方当前票号大于HIS当前票号不允许换开.");
		return;
	}
	if(rows != ""){
		if(rows.RateStatus=="1"){
			$.messager.alert("提示","该票据已经是纸质票据，不能在换开纸质票据");
			return;
		}
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="PrintPaper";
		var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
		var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
		alert(PayAdmType+"^"+HISPrtRowID+"^"+OrgHISPrtRowID)
		alert(ExpStr)
		//return;
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("提示","该票据换开失败,错误原因:"+rtn.split("^")[1]);
			}else{
				$.messager.alert("提示","该票据换开成功");
				$('#DataList').datagrid('load');
				GetStockBillNo("");           //重新获取当前票号
				//patInvPrint(PayAdmType, prtRowIdStr);				//his自己打印发票(入参为业务类型和发票号)
				PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //调用博思打印
			}
		});
	}
}


///重新换开纸质票据
function reTurnPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("提示","换开纸质票据时,票号代码与当前可用票号不能为空.");
		return;
	}
	var ErrInfo=$('#ErrMsgInfo').text()
	if(ErrInfo=="第三方当前票号获取失败"){
		$.messager.alert("提示","换开纸质票据时,第三方当前票号获取失败.");
		return;
	}
	
	if(parseInt(ErrInfo)>parseInt(pBillNo)){
		$.messager.alert("提示","换开纸质票据时,第三方当前票号大于HIS当前票号不允许换开.");
		return;
	}
	if(rows != ""){
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="RePrintPaper";
		var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
		var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
		//alert(PayAdmType+"^"+HISPrtRowID+"^"+OrgHISPrtRowID)
		//alert(ExpStr)
		//return;
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("提示","该票据换开失败,错误原因:"+rtn.split("^")[1]);
			}else{
				$.messager.alert("提示","该票据换开成功");
				$('#DataList').datagrid('load');
				//UpDateDHCInvoice()         //换开成功后，更新发票发放表  //-dongkf 2020 01 03 后台的换开业务中执行了走号方法，所以这里不需要再走号
				GetStockBillNo("");          //重新获取当前票号
				
				//patInvPrint(PayAdmType, prtRowIdStr);			//打印发票，调用我们HIs自己发票模板打印
				PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //调用博思打印
			}
		});
	}
	
}


///获取第三方(博思)当前票号（用于能区分开住院，门诊）
/// add by xubaobao 2021 06 11 将LogicIUDType--> BillBatchNo
function GetStockBillNoBSOld(BillBatchNo){
	var InputPam=UserID+"^"+BillBatchNo;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetStockBillNo",
		InputPam:InputPam,
		PathCode:"PaperNo"
		},function(rtn){
			if (rtn==""){
	        	$('#ErrMsgInfo').text("第三方当前票号获取失败");
			}else{
				$('#ErrMsgInfo').text(rtn.split("^")[1]);
			}
	       
	});		
	
}


///获取第三方(博思)当前票号（用于不能区分门诊住院）
function GetStockBillNoBS(BillBatchNo,EndInv){
	var InputPam=UserID+"^^"+BillBatchNo+"^"+EndInv;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetCurBillNoByEndInv",
		InputPam:InputPam,
		},function(rtn){
			if (rtn==""){
	        	$('#ErrMsgInfo').text("第三方当前票号获取失败");
			}else{
				$('#ErrMsgInfo').text(rtn);
			}
	       
	});		
	
}

///获取当前票号(发放表获取当前票号)
///w ##class(web.udhcOPBillIF).GetreceipNO("dddddd","","639^Y")
function GetStockBillNo(LogicIUDType){
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	
	$('#ErrMsgInfo').empty();           //错误消息清空
	$("#IUDBillBatchNo").val("");       //票据代码
	$("#PresentNo").val("");            //票据号码
	
	
	///操作员^票据类型^安全组^费别^院区
	var AdmReasonId=""
	var OutMsg=""
	var InputPam=UserID+"^"+LogicIUDType+"^"+Group+"^"+AdmReasonId+"^"+Hospital;	 
	 $.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetPaperBillNo",
		InputData:InputPam,
		OutMsg:OutMsg
		},function(rtn){
			if(rtn.split("^")[0]<0){
	        	$('#ErrMsgInfo').text(rtn.split("^")[1]);
	        }else{
		        $('#ErrMsgInfo').empty();
		        $("#IUDBillBatchNo").val(rtn.split("^")[3]);  
		        $("#PresentNo").val(rtn.split("^")[0]);  
		        
		        GetStockBillNoBSOld(rtn.split("^")[3]);  //(纸质票据区分门诊住院类型时)
		        
		        //GetStockBillNoBS(rtn.split("^")[3],rtn.split("^")[2]);		//add by xubaobao 2020 09 07 获取第三方当前票号(纸质票据不区分门诊住院类型时)
	   		}
	  });		
	
}

function setIUDPayAdmType(){
	var DicCode=$('#AdmType').combobox('getValue');
	$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"AdmType",
		DicCode:DicCode,
		ind:"5"
		},function(rtn){
			//$('#IUDPayAdmType').combobox('setValue',rtn);   ？？？就诊类型、票据类型Code不一致
			GetStockBillNo(rtn);		 
	});	
}
///清屏
function Clear(){
	$('#stDate').datebox('setValue',"");
	$('#edDate').datebox('setValue',"");
	$('#AdmType').combobox('setValue',"");
	$('#operator').combobox('setValue',"");
	$("#rmarkNo").val("")
	//FindData();
	
}
///换开成功后更新发票发放表
function UpDateDHCInvoice()
{
	/*
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	*/
	var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	
	var PresentNo=$("#PresentNo").val()
	var InputPam=UserID+"^"+PresentNo+"^"+LogicIUDType
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"UpDateDHCINvoice",
		InputPam:InputPam
		},function(rtn){
        if (rtn=="0")
        {   
        	setIUDPayAdmType()         //重新获取当前票号
	    }else 
	    {
		   $.messager.show({title:'提示',msg:'更新发票发放表失败！',timeout:1000,showType:'slide'});
		  }
	});	
	
}

///his发票打印(区分门诊和住院)
function patInvPrint(PayAdmType, prtRowIdStr)
{
	try{
		if (PayAdmType == ""){
			$.messager.alert("提示","患者就诊类型为空,请核查.");
			return;
		}
		
		if ((PayAdmType == "OP")||(PayAdmType == "REG")){
			OPPatInvPrint(prtRowIdStr);				//门诊发票打印
		}else if(PayAdmType == "IP"){
			IPPatInvPrint(prtRowIdStr);				//住院发票打印
		}
		
	}catch (e) {
		$.messager.alert("打印异常:" + e.message);
	}
	
}

///打印纸质发票--调用博思打印接口
function PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)
{
	
	if ((pBillBatchCode=="")||(pBillNo=="")){
		
	var rows = $('#DataList').datagrid('getChecked');
	pBillBatchCode=rows[0].IUDBillBatchCode ;                      // $("#IUDBillBatchNo").val();
    pBillNo=rows[0].IUDBillBatchNo;                                 //$("#PresentNo").val();
	PayAdmType=rows[0].IUDPayAdmType;	
	}
	/*
    alert("打印纸质票据="+pBillBatchCode+"^"+pBillNo);
    var param = {
		'pBillBatchCode':pBillBatchCode,
		'pBillNo':pBillNo  
		//,'pBillCode': '4014'
	}
	    //alert(pBillBatchCode+"^"+pBillNo); printPaperBill
		industry.jsRequest('printPaperBill', '1.0', param).then(function (data) {
            if(data&&data.result!='S0000'){
	            alert("打印成功");
            }
            console.log("success");
        }).fail(function (data) {
            console.log( data);
        }); 
        //GetStockBillNo(""); 
        */
        
        /*
        var param = {
            'pBillBatchCode': pBillBatchCode,
            'pBillNo': pBillNo,
            'pBillCode': '4014'
        }
        industry.printPaperBill(param, '1.0', false).then(function (data) {
            if(data&&data.result!='S0000'){
                alert(data.message)
            }
            console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
        */
        
        var pBillCode="";
        if (PayAdmType == "OP"){
	        pBillCode="4014";
        }
        
        if (PayAdmType == "IP"){
	        pBillCode="4015";
        }
       
        var param = {
            'pBillBatchCode': pBillBatchCode,
            'pBillNo': pBillNo,
            'pBillCode': pBillCode
        }
        industry.printPaperBill(param, '1.0', true).then(function (data) {
            if(data&&data.result!='S0000'){
                alert(data.message)
            }
            //console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
      
		
}


/// 换开电子票
/// add by xubaobao 2020 09 08 
function ReTurnEPaper()
{
	var rows = $('#DataList').datagrid('getChecked');
	if(rows != ""){
		if(rows.RateStatus=="1"){
			$.messager.alert("提示","该票据是纸质票据，请选择电子票据进行电子票据换开");
			return;
		}
		
		//冲红第三方数据
		var PayAdmType=rows[0].IUDPayAdmType;
		var HISPrtRowID=rows[0].IUDInvDr;
		var OrgHISPrtRowID=rows[0].IUDInitRowID;
		var PathCode="InvalidInvSvr";
		var ExpStr="";    
		$m({
			ClassName:"BILL.EINV.BL.EInvoiceLogic",
			MethodName:"InvocieBill",
			PayAdmType:PayAdmType,
			HISPrtRowID:HISPrtRowID,
			OrgHISPrtRowID:OrgHISPrtRowID,
			PathCode:PathCode,
			ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("提示","该票据冲红失败,错误原因:"+rtn.split("^")[1]);
			}else{
				InvocieBill(PayAdmType,HISPrtRowID)
			}
		});
	}
}

/// 开电子票
/// add by xubaobao 2020 09 08 
function InvocieBill(PayAdmType,HISPrtRowID){
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:"",
		PathCode:"",
		ExpStr:""
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			$.messager.alert("提示","开电子票失败,错误原因:"+rtn.split("^")[1]);
		}else{
			$.messager.alert("提示","电子票换开成功");
		}
	});
	
}



// add by xubaobao 2021 07 30
// 批量换开纸质票据
function EInvPrintAll()
{
	var rows = $('#DataList').datagrid('getChecked');;
	if(rows.length>0){
		var PathCodeTmp="PrintPaper";
		var ErrMsgTmp="";
		TurnPaperDo(rows, 0, ErrMsgTmp, PathCodeTmp);   逐个开票
	}else{
		alert("请选择一条记录!");
	}
}

/// 功能说明：发票打印
function TurnPaperDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var pBillBatchCode= $("#IUDBillBatchNo").val();
	var pBillNo= $("#PresentNo").val();
	if((pBillBatchCode=="")||(pBillNo=="")){
		$.messager.alert("提示","换开纸质票据时,票号代码与当前可用票号不能为空.");
		return;
	}
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //本次开票数目
	var nowInvRecInfo=CheckedRecs[i];   //当前票据记录
	var InvRecIndex=$('#DataList').datagrid('getRowIndex', nowInvRecInfo);   //当前票据所在行索引
	
	var PayAdmType=nowInvRecInfo.IUDPayAdmType;
	var HISPrtRowID=nowInvRecInfo.IUDInvDr;
	var OrgHISPrtRowID=nowInvRecInfo.IUDInitRowID;
	
	var ExpStr=UserID+"^"+Group+"^"+Loc+"^"+Hospital+"^"+pBillBatchCode+"^"+pBillNo;
	var prtRowIdStr=HISPrtRowID+"#"+"R";      //suihuide
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:OrgHISPrtRowID,
		PathCode:PathCode,
		ExpStr:ExpStr
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			ErrMsgTmp="第["+(InvRecIndex+1)+"]行票据上传失败:"+rtn.split("^")[1];
			if(ErrMsg==""){
				ErrMsg=ErrMsgTmp;
			}else{
				ErrMsg=ErrMsg+"\n"+ErrMsgTmp;
			}
			//$.messager.alert("提示","该票据换开失败,错误原因:"+rtn.split("^")[1]);
		}else{
			//$.messager.alert("提示","该票据换开成功");
			$('#DataList').datagrid('load');
			GetStockBillNo("");           //重新获取当前票号
			//patInvPrint(PayAdmType, prtRowIdStr);				//his自己打印发票(入参为业务类型和发票号)
			PrintBtnBS(pBillBatchCode,pBillNo, PayAdmType)      //调用博思打印
			
			
			NextIndex=i+1;    //下一个条记录
			if(NextIndex<AllRecLen){
				InvoiceDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
			}else{
				if(ErrMsg!=""){
					alert(ErrMsg);
				}else{
					alert("票据换开成功!");
				}
			}
			
		}
	});
		
}
