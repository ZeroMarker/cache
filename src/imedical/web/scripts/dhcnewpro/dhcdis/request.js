/// Creator: huaxiaoying
/// CreateDate: 2017-01-19
var requested=0 //区分是否已申请
var SelByAdm="" //按条件查找患者
var rowDataS="" 
var PatAdm="";  //就诊ID   add by sufan 选择病人，进入陪送申请界面，默认选中在床位图选中的病人，用于传病人的就诊号
$(document).ready(function() {
	
	
	PatAdm = getParam("EpisodeID");			// 取床位图已选病人的就诊号
	$HUI.checkbox("#Adm",{
		onCheckChange:function(e,value){
			 var Ord = $('#DisReqOrdTb').datagrid('getRows');
	         if (Ord) {
	             for (var i = Ord.length - 1; i >= 0; i--) {
	                 var index = $('#DisReqOrdTb').datagrid('getRowIndex', Ord[i]);
	                 $('#DisReqOrdTb').datagrid('deleteRow', index);
	             }
	         }
	        $('#DisReqOrdTb').datagrid('loadData', { total: 0, rows: [] });
			if($('#Adm').is(':checked')){
				SelByAdm="EO;"
				rowData="";
				GetSearchInfo()
				hideControl();
			}
			else
			{
				SelByAdm=""
				GetSearchInfo();
				hideControl();
			}	
		}	
	});
	
	initDate();  		//初始化日期框
	initCombo();		//初始化combo
	initMethod();  		//初始化控件绑定的事件
	initDatagrid(); 	//初始化datagrid
	initdistable(); 	//初始化申请单
	$('#regNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            regNoBlur()
        }
    });
    //医嘱名称查找
    $('#OrdName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#DisReqOrdTb','formid':'#queryForm'}); //调用查询
        }
    });
    //其他名称查找
    $('#OthName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#DisReqOthTb','formid':'#queryFormOth'}); //调用查询
        }
    });
    //$('#Adm').click(function({}))

	
	//医嘱/其他只选择一个
	$('#tab').tabs({      
        onSelect:function(title){    
	        if(title=="医嘱"){
		       //其他
			    $('#DisReqOthTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
				});	
	        }else{
		        $('#DisReqOrdTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListOrd&EpisodeID='+PatAdm
				});	
		        //其他
			    $('#DisReqOthTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
				});	
		    }
	    }    
	});
	$('#PatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
           
			var PatNo=$("#PatNo").val();
			$('#PatNo').val(getpatno(PatNo));
			GetSearchInfo();
			
        }
    });
    $('#PatNoSearch').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
           
			var PatNo=$("#PatNoSearch").val();
			$('#PatNoSearch').val(getpatno(PatNo));
			GetSearchInfo();
			
        }
    });
    
	$('#DisReqOrdTb').datagrid('loadData', {total:0,rows:[]});
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
})

/// 补全登记号位数
function getpatno(patno)
{
	var patnolen=patno.length;
	var len=10-patnolen
	for (var i=0;i<len;i++)
	{
		patno="0"+patno;
		}
	if(patno=="0000000000"){
		patno="";
	}
	return patno;
}
function initDatagrid()
{
	if(LocDesc.indexOf("陪送中心") != "-1")
	{
		initPatform();
		initPatList();
	}else{
		initform(); //初始化表单录入框
		inittable(); //初始化table 患者列表
		$HUI.checkbox("#Adm").disable();
		$HUI.combobox("#VisLoc").setValue(LgCtLocID);
		$HUI.combobox("#VisLoc").disable()
		}
}
//初始化combobox
function initCombo(){
	$('#ApplayLocS').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatusS').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: 陪送 ,1: 配送
		valueField:'id',
	    textField:'text',
	    onSelect:function(record){
		},
	});
	var code=""
	if(LocDesc.indexOf("陪送中心") != "-1")
	{
		code=11;
	}else{
			code=10;
		}
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':code},function(data){
		$('#AffirmStatusS').combobox("setValue",data);
	},'text',false)
	
	///初始化陪送人员下拉框
	$('#Escortper').combobox({
		url:'', //LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID,
		valueField:'value',
	    textField:'text',
	    mode:'remote',
	    onShowPanel: function () { //数据加载完毕事件
			///设置级联指针
			var unitUrl = LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID;
			$("#Escortper").combobox('reload',unitUrl);
        }
	    
	});

}
///默认陪送时间 zwq
function InitDateTimeBox()
{
	$("#StartDate").datebox("setValue",formatDate(0));   ///陪送日期
	
	
}
///初始化申请单列表
function initdistable()
{
	var columns = [[
		
		{
	        field: 'ck',
	        checkbox:'true',
	        //align: 'center',
            
	    },{
	        field: 'patname',
	        //align: 'center',
            title: '姓名'
	    },
	    {
	        field: 'hosno',
	        //align: 'center',
            title: '住院号'
	    },
     	{
	        field: 'mainRowID',
	        //align: 'center',
	        hidden: true,
            title: '申请单ID'
	    },{
	        field: 'newStatus',
	        //align: 'center',
            title: '当前状态'
	    },{
	        field: 'TypeID',
	        //align: 'center',
	        hidden: true,
            title: '类型ID'
	    },{
            field: 'applyDate',
            //align: 'center',
            title: '申请日期'
        }, {
            field: 'currregNo',
            //align: 'center',
            title: '登记号'
        }, {
            field: 'bedNo',
            //align: 'center',
            title: '床号'
        }, {
            field: 'endemicArea',
            //align: 'center',
            title: '病区'
        }, {
            field: 'taskID',
            //align: 'center',
            title: '验证码',
            hidden: true
        },{
            field: 'acceptLoc',
            //align: 'center',
            title: '接收科室',
            hidden: true
        },{
            field: 'dispeople',
            //align: 'center',
            title: '陪送人员'
        }, { 
            field: 'deliveryDate',
            //align: 'center',
            title: '陪送日期'
        },  {
            field: 'deliveryWay',  
            //align: 'center',
            title: '陪送方式'
        }, {
            field: 'deliveryType',
            //align: 'center',
            title: '陪送类型'
        }, 
       {
            field: 'remarkDesc',
            //align: 'center',
            title: '备注'
        }, {
            field: 'nullFlag',
            //align: 'center',
            title: '空趟',
            hidden: true
        }, {
            field: 'AssNumber',
            //align: 'center',
            title: '评分',
        }, {
            field: 'AssRemarks',
            //align: 'center',
            title: '评价',
           
        }
        ]]
    var param=getinParam(); //获取参数
    var rowData=$('#DisReqPatTb').datagrid('getSelected');  //获取患者就诊ID
    var AdmNo="";
    if(rowData!=null)
    {
	    AdmNo=rowData.Adm;
	}
    $('#cspAffirmStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdEscort&param='+param+'&PatLoc='+LgCtLocID+'&AdmNo='+AdmNo+'&HospID='+LgHospID,
	    fit:true,
	    rownumbers:true,
	    //fitColumns:true,
	    columns:columns,
	    pageSize:100, // 每页显示的记录条数
	    pageList:[100,200],   // 可以设置每页记录条数的列表
	    //singleSelect:true,
	    loadMsg: '正在加载信息...',
	    pagination:true,
	    onSelect:function(Index, row){
		    ClickRowDetail(row.mainRowID);
	        rowDataS= row;
	    },
	    onUnselect:function (Index, row){
			rowDataS= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail(row.mainRowID);
		},
		onLoadSuccess: function () {   //隐藏表头的checkbox
           //$("#cspAffirmStatusTb").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
        	
        }
	})
	
	var columnsdetail = [[
		{
	        field: 'projectName',
	        //align: 'center',
	        title: '项目名称',
	        width: 250	        
        },{
            field: 'toBourn',
            //align: 'center',
            title: '去向',
            width: 200
        }
        ]]
		
	$('#cspAffirmStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '正在加载信息...',
	    pagination:true,
	    nowrap:false//数据自动换行
    })
}

//查询项目明细
function ClickRowDetail(DisMainRowId){
	//var row =$("#cspAffirmStatusTb").datagrid('getSelected');
	//DisMainRowId=row.mainRowID; //申请id
	$('#cspAffirmStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdDetail&DisMainRowId='+DisMainRowId
	});
	
}
function getinParam(){
	var stDate = $('#StrDateS').datebox('getValue');
	var endDate=$('#EndDateS').datebox('getValue');
	var taskID= $('#TaskIDS').val();
	var regno = $('#RegNoS').val();
	var applayLocDr= $('#ApplayLocS').combobox('getValue');
	var DisHosNo = $('#HosNoS').val();
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatusS').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+regno+"^"+applayLocDr+"^"+affirmStatus+"^"+DisHosNo;
}
///初始化日期框
function initDate()
{
	$('#StrDateS').datebox("setValue",formatDate(0));
	$('#EndDateS').datebox("setValue",formatDate(0));
	$("#StDate").datebox("setValue",formatDate(0));	 	 ///开始日期
	$("#EndDate").datebox("setValue",formatDate(0));	 ///结束日期
}
// 初始按钮绑定方法
function initMethod(){
	 $('#save').bind('click',save);
	 //回车事件
     $('#RegNoS').bind('keypress',RegNoBlur);
     $('#search').bind('click',GetSearchInfo)  		//查找患者列表
     $('#exeBtn').bind('click',DisAffirm);       	//陪送确认
     $("#undoBtn").bind('click',Undorequest)		//撤销申请
 	 $('#searchBtn').bind('click',search) 			//查找
 	 //$('#nullflagBtn').bind('click',SetNullFlag)  //设置空趟标识
 	 $('#requestCopy').bind('click',RequestCopy) 	//复制陪送申请
 	  $("#detailsbtn").bind('click',ParticularsPages) //详情
 	 
 	 $("#appraiseBtn").on('click',function(){
		if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
		//dws 2017-02-24 评价权限  
		if((($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="完成确认")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="已评价")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="空趟")){
			
			appraise(); //打开评价界面
		}
		else{
			$.messager.alert("提示","请完成确认申请单后再评价!");
		}
	 })
	 
}
//登记号回车事件
function RegNoBlur(event)
{
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("提示","登记号长度输入有误！");
		    $('#RegNo').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#RegNo").val(Regno);
    }
}
//查询
function search(){
	/*if(LocDesc!="后勤管理配送组"){
		var AdmSelectRow=$('#DisReqPatTb').datagrid('getSelected');
		if(AdmSelectRow==null)
		{
			$.messager.alert("提示:","请选择患者!");
			return;
		}
	}*/
	var AdmNo="";  //获取患者就诊ID 
	var Params=getinParam(); //获取参数
	$('#cspAffirmStatusTb').datagrid({
			queryParams:{"param":Params,"PatLoc":LgCtLocID,"AdmNo":AdmNo,HospID:LgHospID}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
}
///医嘱的单击事件 涉及接收科室 2017-02-24
function onClickOrdRow(rowIndex, rowData){
	var lenOrd=$("#DisReqOrdTb").datagrid('getSelections').length;
	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	if(lenOth>0)
	{
		$.messager.alert("提示:","已选择其他项目，不能再选择医嘱!");
		$(this).datagrid('unselectRow', rowIndex);
		return;
	}
	if(lenOrd>0)
	{
		$('#RecLoc').combobox('setValue',"");
	}
	setDisReqWay();
}

///医嘱的单击事件 涉及接收科室 2017-05-05   zhl
function onUnClick(rowIndex, rowData){
	//deleteon(rowData,rowIndex);
	len=$("#DisReqOrdTb").datagrid('getSelections').length;
	if(len<1)
	{
		$("#RecLoc").combobox("setValue","");
	}
}

///zhl医嘱的单击事件
function deleteon(rowData,rowIndex){
      var data = $('#DisReqSelectedProjectTb').datagrid('getData');
      for(var i=0;i<data.rows.length;i++){
            var row = data.rows[i].Index;
            if(rowIndex==row){
	            var Index = $('#DisReqSelectedProjectTb').datagrid('getRowIndex', data.rows[i]);
	            $('#DisReqSelectedProjectTb').datagrid('deleteRow', Index); 
            }
        }
}

///zhl医嘱的单击事件
function insertd(rowData,rowIndex) {
               $('#DisReqSelectedProjectTb').datagrid("insertRow", { 
                       //这里还有一个index参数，可指定添加到某行。如果不写，默认为在最后一行添加
                   row: {
                         ReqDesc:rowData.arcItmDesc,
                         ExelocDesc:rowData.recLoc,
                         Index:rowIndex   
                   }
               });
}
function onClickOthRowWuNai(rowIndex, rowData)  //超级无奈   好孤独  ?.?
{
	$.messager.alert("提示:","已选择医嘱,不能再选择其它项目!");
	onClickOthRowWuNai(rowIndex, rowData);
}
///其他的单击事件 涉及接收科室 2017-02-23
function onClickOthRow(rowIndex, rowData){
	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	if(len>0)
	{
		$.messager.alert("提示:","已选择医嘱,不能再选择其它项目!");
		$(this).datagrid('unselectRow', rowIndex);
		return;
	}
	setDisReqWay();
	
	if(rowData.TypeFlag==3){
		$("#ReqWay").combobox("setValue",'')
	}
}

///医嘱的单击事件 涉及接收科室 2017-05-05   zhl
function onUnClicki(rowIndex, rowData){
	//deleteoni(rowData,rowIndex)	
	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	if(lenOth==0)
	{
		$("#RecLoc").combobox("setValue",'');
	}
}

///zhl医嘱的单击事件
function deleteoni(rowData,rowIndex){
      var data = $('#DisReqSelectedProjectTb').datagrid('getData');
      for(var i=0;i<data.rows.length;i++){
            var row = data.rows[i].Indexi;
            if(rowIndex==row){
	            var Indexi = $('#DisReqSelectedProjectTb').datagrid('getRowIndex', data.rows[i]);
	            $('#DisReqSelectedProjectTb').datagrid('deleteRow', Indexi); 
            }
        }
}
///zhl其他的单击事件
function insert(rowData,rowIndex) {
               $('#DisReqSelectedProjectTb').datagrid("insertRow", { 
                       //这里还有一个index参数，可指定添加到某行。如果不写，默认为在最后一行添加
                   row: {
                         ReqDesc:rowData.LIDesc,
                         ExelocDesc:rowData.LIlocDesc,
                         Indexi:rowIndex 
                   }
               });
}

///补零方法
function regNoBlur()
{   
	var i;
    var regNo=$('#regNo').val();
    var oldLen=regNo.length;
    if (oldLen==10) return;
	if (regNo!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regNo="0"+regNo 
	    }
	}
    $("#regNo").val(regNo);
}
///保存
function save(){
	if(requested==1){
		$.messager.alert("提示","申请请在[患者列表]处单击病人后填写申请并保存！");
		return;
	}                
	var regNo=$('#regNo').val();
	var BedId=$('#BedId').val();//
	var bedNo=$('#bedNo').val();
	var wardId=$('#wardId').val();//
	var ward=$('#ward').val();
	var jobId=$('#jobId').val();
	var RecLoc=$('#RecLoc').combobox('getValue');
	var Date=$('#StartDate').datebox('getValue');
	
	var DateFlag=serverCall("web.DHCDISRequest","JudgeDate",{"Date":Date})
	var TimePoint=$('#Time').combobox('getText');

	var TimeValue=$('#Time').combobox('getValue');
	var TimeFlag=serverCall("web.DHCDISRequest","JudgeTime",{"Date":Date,"Time":TimePoint})
	//var TimePoint=$('#TimePart').combobox('getText');
	var Time=""
	var StartDate=Date+" "+Time+" "+TimePoint
	var ReqType=$('#ReqType').combobox('getValue');
	var ReqWay=$('#ReqWay').combobox('getValue');
	var ReqNum=1;
	var note=$('#note').val()
	note = note.replace(/\^/g,'');
	var EscortPer=$("#Escortper").combobox("getValue")	//获取护工ID sufan   2018-01-02
	var EpisodeID=$('#EpisodeID').val();
	var Othsel=$("#DisReqOthTb").datagrid('getSelections');  //选择其他项目是必须选择科室  zwq
	var lenOth=Othsel.length;
	var ReqTypeText=$('#ReqType').combobox('getText');
	var ReqWayText=$('#ReqWay').combobox('getText');
	if(regNo==""){
		$.messager.alert("提示","请单击患者列表病人自动带入登记号！");//请填写登记号！
	}
	else if(jobId==""){
		$.messager.alert("提示","请单击患者列表病人自动带入任务ID！");
	}else if((lenOth!=0)&&(RecLoc=="")&&(Othsel[0].RecLocFlag=="Y")){
		$.messager.alert("提示","请选择接收科室！");
	}else if(Date==""){
		$.messager.alert("提示","请选择陪送日期!");
	}else if((DateFlag==0)&&(LocDesc.indexOf("陪送中心") ==-1)){
		$.messager.alert("提示","陪送日期小于当前日期!");
	}else if(TimePoint==""){
		$.messager.alert("提示","请选择陪送时间！"); 
	}else if(TimeValue==undefined){
		$.messager.alert("提示","时间格式有误,请选择陪送时间！"); 
	}else if((ReqWay=="")||(ReqWayText=="")){
		$.messager.alert("提示","请选择陪送方式！");
	}else if(ReqWay==undefined){
		$.messager.alert("提示","陪送方式数据有误,请选择陪送方式！");
	}else if((TimeFlag==0)&&(LocDesc.indexOf("陪送中心") =="-1")){
		$.messager.alert("提示","陪送时间小于当前时间!");
	}else if(ReqNum==""){
		$.messager.alert("提示","请选择陪送人数！");
	}else if((ReqType=="")||(ReqTypeText=="")){
		$.messager.alert("提示","请选择陪送类型！");
	}else if(ReqType==undefined){
		$.messager.alert("提示","陪送类型数据有误,请选择陪送类型！");
	}else if((EscortPer=="")&&(LocDesc.indexOf("陪送中心") != "-1")){
		$.messager.alert("提示","请选择陪送人员！");
	}else{
		var str=jobId+"^"+wardId+"^"+BedId+"^"+EpisodeID+"^"+regNo+"^"+RecLoc+"^"+StartDate+"^"+ReqType+"^"+ReqWay+"^"+ReqNum+"^"+note+"^"+LgCtLocID+"^"+UserID+"^"+LgHospID //+"^"+Item+"^"+ItemType+"^"+ExeLocDr
		var strObjs="" //项目串
		var rows =$("#DisReqOrdTb").datagrid('getSelections');
		var rowsOth =$("#DisReqOthTb").datagrid('getSelections');
		if ((rows.length==0)&&(rowsOth.length==0)) {
			 $.messager.alert("提示",'请选择项目行(医嘱/其他)！'); 
			 return  
	    }else{
			for(var i = 0; i<rows.length;i++){
				strObjs=strObjs+rows[i].arcItmId+"^"+rows[i].Type+"^"+rows[i].recLocID+"$$"
			}
			for(var j = 0; j<rowsOth.length;j++){
				strObjs=strObjs+rowsOth[j].ID+"^"+rowsOth[j].Type+"^"+rowsOth[j].LIlocDr+"$$"
			}
	    }
	    runClassMethod("web.DHCDISRequest","isReqItmRepeat",{'str':str,'strObjs':strObjs},
			function(data){
				if(data=="")
				{
					$.messager.confirm('确认','您确认保存该陪送申请吗？',function(r){   
		   			 if (r){
								SaveRep(strObjs,str,EscortPer)     ///调用保存函数
		    				}
		   				 })	
				}else{
	 				$.messager.confirm('确认','<font style="color:red">'+data+'</font>'+'已经申请过是否再申请？',function(r){   
		   			 if (r){
								SaveRep(strObjs,str,EscortPer)     ///调用保存函数
		    				}
		   				 })		
	 				}		
			},"text",false)
		}   
	
}
///保存申请的数据
function SaveRep(strObjs,str,EscortPer)
{
	runClassMethod("web.DHCDISRequest","Save",
	    {'str':str,
	     'strObjs':strObjs},
			function(data){
				if(data<0)
				{
                	$.messager.alert("提示","保存失败");  //sufan  2017-11-23 
				}else{
	 			
	 				AutoArrangement(data,EscortPer);
                	search();
                	$('#DisReqOrdTb').datagrid('load');
                	$('#DisReqOthTb').datagrid('load');
                	//$('#DisReqpatReqedTb').datagrid('load');
                	var Params=getinParam(); //获取参数
					$('#cspAffirmStatusTb').datagrid({
						queryParams:{param:Params,AdmNo:PatAdm}	
					})
	 			}	
			},"text",false)
}

///初始化表单录入框
function initform(){
	$('#VisLoc').combobox({ //就诊科室    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(option){
	        //GetSearchInfo();
	    }       
	});
	$('#RecLoc').combobox({ //接收科室    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(){
	    	
	    	var Othsel=$("#DisReqOthTb").datagrid('getSelections');
	    	var lenOth=Othsel.length;
	    	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	    	
	    	if(len==0)
	    	{
				if(lenOth==0)
	    		{
		    		$('#RecLoc').combobox('setValue',"");
		    		$.messager.alert("提示:","请先选择其他项目!");
		    		return;
		    	}else if(Othsel[0].RecLocFlag!="Y")
		    		{
			    		 $('#RecLoc').combobox('setValue',"");
			    	}
		    }
		    else
		    {
			   $('#RecLoc').combobox('setValue',"");
		    	//$.messager.alert("提示:","已选择医嘱项目，不能选择接收科室!");
		    	return; 
			}
	    }
    
	});  

	$('#ReqType').combobox({ //陪送类型   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#ReqWay').combobox({ //陪送方式 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#Time').combobox({ //陪送时间 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	/* $('#TimePart').combobox({ //陪送时间段 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	}); */
	/*$('#ReqNum').combobox({ //陪送人数   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",    
	    valueField:'id',    
	    textField:'text',
	    onSelect: function () {
				//获取选中的值
				var varSelect = $(this).combobox('getValue');
				runClassMethod("web.DHCDISRequest","GetNowReqNum",
			    {Loc:varSelect},
				function(data){
					if(data<varSelect){
						$.messager.alert("提示","当前空闲人数为 "+data+" 人!");
					}
				});	
								
		}  
	});*/

}
/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){
	if(SelByAdm=="")
	{
		var BedInfo=rowData.PatBed;
		if(BedInfo!=""){BedInfo=BedInfo+"床"}
		else{BedInfo="等候区"}
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;"><span style="color:red;">' + BedInfo+'</span></h3><h3 style="margin-left:5px;float:left;background-color:transparent;">'+ rowData.PatName + '</h3><br>';
	} 
	else
	{
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName + '</h3><br>';
	} 
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}
/// 病人信息列表  卡片样式 已申请
function setReqedCellLabel(value, rowData, rowIndex){
	var htmlstr =  '<div class="celllabel"><h3 style="float:right;background-color:transparent;"><span style="color:red;">'+ rowData.PatBed+"床"+'</span></h3><h3 style="margin-left:5px;float:left;background-color:transparent;">'+ rowData.PatName +'</h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';

		if(rowData.NurseLevel!=""){
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"></h4>';
		}
		htmlstr = htmlstr +'<h3 style="float:left;color:#000;background-color:transparent;">'+ rowData.CreateDate +'</h3>';
		htmlstr = htmlstr +'<h3 style="float:left;color:red;background-color:transparent;">'+ rowData.ExeDate +'</h3>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}
///清空form表单
function clearForm(){
	//文本框
	/*$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})*/
	// Combobox
	/*$('input.combobox-f').each(function(){
		$("#"+ this.id).combobox("setValue","");
	})*/
	// 日期时间
	$('input.datetimebox-f').each(function(){
		$("#"+ this.id).datetimebox("setValue","");
	})
	$("#EpisodeID").val("");
	$("#BedId").val("");
	$("#wardId").val("");
}
//查找对应患者申请单
function selAdmReq(rowData)
{
	var Params=getinParam(); //获取参数
	
	$('#cspAffirmStatusTb').datagrid({
		queryParams:{param:Params,AdmNo:rowData.Adm}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}
///table重写url
function rewTbUrl(rowData){
	//已选项目
	/* $('#DisReqSelectedProjectTb').datagrid({  
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListSelected&AdmNo='+rowData.Adm
	});	 */
    //医嘱
  
    $('#DisReqOrdTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListOrd&EpisodeID='+rowData.Adm
	});	
	
    //其他
    $('#DisReqOthTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
	});	
	/* //申请单列表
	$('#cspAffirmStatusTb').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param+'&AdmNo='+rowData.Adm
	}); */
}
///赋值form表单
function setForm(rowData){
	setDisReqType();
	setDisReqWay();
	//$('#ReqNum').combobox("setValue","1");   //默认护工数量
	InitDateTimeBox();  //默认datetimebox数值
	var regNo=$('#regNo').val(rowData.PatNo);
	var bedNo=$('#bedNo').val(rowData.PatBed);
	var ward=$('#ward').val(rowData.AdmWard); 
	var wardId=$('#wardId').val(rowData.AdmWardDr);
	var EpisodeID=$('#EpisodeID').val(rowData.Adm); 
	var BedId=$('#BedId').val(rowData.BedId);
	var type=0
	runClassMethod("web.DHCDISRequest","getVerfiyCode",
			    {'type':type},
				function(data){
					var jobId=$('#jobId').val(data);
	},'text');			
	///清空
	$HUI.combobox("#RecLoc").setValue("");
	InitDateTimeBox();
	$HUI.combobox("#Time").setValue("");
	$("#note").val("");
	$HUI.combobox("#Escortper").setValue("");
}
/// sufan 2017-11-28 动态给陪送方式设置默认值
function setDisReqWay()
{
	runClassMethod("web.DHCDISRequest","DisToolList",{"HospID":LgHospID},function(jsonString){
		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ReqWay").combobox('loadData',jsonString);   	// 加载接收科室combobox的数据
			for(var i=0;i<jsonObjArr.length;i++){
				$("#ReqWay").combobox('select', jsonObjArr[0].id);	
			}     
		}
	},'json',false)
}
/// sufan 2017-11-28 动态给陪送类型设置默认值
function setDisReqType()
{
	runClassMethod("web.DHCDISRequest","DisTypeList",{"HospID":LgHospID},function(jsonString){
		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ReqType").combobox('loadData',jsonString);   	// 加载接收科室combobox的数据
			for(var i=0;i<jsonObjArr.length;i++){
				$("#ReqType").combobox('select', jsonObjArr[0].id);	
			}     
		}
	},'json',false)
}
///赋值form表单(已申请列表赋值)
function setFormShow(rowData){
	var regNo=$('#regNo').val(rowData.PatNo);
	var bedNo=$('#bedNo').val(rowData.PatBed);
	var ward=$('#ward').val(rowData.REQWard); 
    var jobId=$('#jobId').val(rowData.REQNo); 
	var note=$('#note').val(rowData.Remarks);
	// Combobox
	$("#RecLoc").combobox("setValue",rowData.REQRecLocDr);
	$("#ReqType").combobox("setValue",rowData.EscortTypeDr);
	$("#ReqWay").combobox("setValue",rowData.EscortToolDr);
	//$("#ReqNum").combobox("setValue",rowData.Nums);
	// 日期时间
	$("#StartDate").datetimebox("setValue",rowData.ExeDate);
}
///初始化table
function inittable(){

	//患者列表
	// 定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'登记号',width:100,hidden:true},
		{field:'PatName',title:'姓名',width:100,hidden:true},
		{field:'PatBed',title:'床号',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'性别',width:100,hidden:true},
		{field:'Adm',title:'就诊ID',width:100,hidden:true},
	]];
	var LocID=LgCtLocID;	///sufan 2018-01-02  将后台的session改为js传值
	var WardID=wardId		//ssion['LOGON.WARDID'];	
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=SelByAdm&SelByAdm="+SelByAdm+"&LocID="+LocID+"&WardID="+WardID,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    pagination:true,
		loadMsg: '正在加载信息...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        PatAdm=rowData.Adm ;   //sufan 2017-12-03
	        clearForm();//清空form表单
	        setForm(rowData);//赋值form表单
	        rewTbUrl(rowData);//table重写url
	        selAdmReq(rowData);//查找对应患者申请单
	        requested=0;//区分是否已申请
	    },
		onLoadSuccess:function(data){
			// 隐藏分页图标
            //$('#List .pagination-page-list').hide();
            var rows = $("#DisReqPatTb").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].Adm==PatAdm)
	            {
		            $('#DisReqPatTb').datagrid('selectRow',i);
		            clearForm();//清空form表单
	        		setForm(rows[i]);//赋值form表单
	        		rewTbUrl(rows[i]);//table重写url
	        		selAdmReq(rows[i]);//查找对应患者申请单
	        		requested=0;//区分是否已申请
				}
	         }
            $('#List .pagination-info').hide();
            
            
		}
	});
	//隐藏刷新
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false}); 
    
    //已申请列表
	// 定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:190,formatter:setReqedCellLabel},
		{field:'PatNo',title:'登记号',width:100,hidden:true,},
		{field:'PatName',title:'姓名',width:100,hidden:true},
		{field:'PatBed',title:'床号',width:100,hidden:true},
		{field:'CreateDate',title:'CreateDate',width:100,hidden:true},
		{field:'ExeDate',title:'ExeDate',width:100,hidden:true}
	]];
	$('#DisReqpatReqedTb').datagrid({
		
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=listRequest",
		fit:true,
	    border:false,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		//pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearForm();//清空form表单
	        setFormShow(rowData);//赋值form表单
	        rewTbUrl(rowData);//table重写url
	        requested=1;//区分是否已申请
	    },
		onLoadSuccess:function(data){
			// 隐藏分页图标
            $('#List .pagination-page-list').hide();
            $('#List .pagination-info').hide();
		}
	});
	//隐藏刷新
    //$('#DisReqpatReqedTb').datagrid('getPager').pagination({ showRefresh: false});   
}
function GetSearchInfo()
{
	var VisDept=$('#VisLoc').combobox('getValue');
	
	var VisDate=$('#VisDate').datebox('getValue');
	var AdmName=$('#AdmName').val();
	if($('#Adm').is(':checked')){
		var PatRegNo=$("#PatNoSearch").val();
	}else{
		
		var PatRegNo=$("#PatNo").val();
	}
	
	var StDate=$("#StDate").datebox("getValue");  	//开始日期
	var EndDate=$("#EndDate").datebox("getValue");  //结束日期
	var Str=VisDept +"^"+ VisDate +"^"+ AdmName +"^"+ PatRegNo +"^"+ StDate +"^"+ EndDate;
	var LocID="";
	if(LocDesc.indexOf("陪送中心") != "-1")
	{
		LocID=VisDept;
	}else if(VisDept!="")
		{ 
			LocID=VisDept; 
		}else{LocID=LgCtLocID}
	
	$('#DisReqPatTb').datagrid({
		queryParams:{SelByAdm:SelByAdm,Str:Str,LocID:LocID}	
	})
}
//  **********************************************
function DisAffirm()
{
	var statuText=$("#AffirmStatusS").combobox("getText")
	if(statuText!="完成")
	{
		$.messager.alert("提示","请根据查询条件“完成”查询出完成的申请，再确认完成！")
		return;	
	}
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');  /// sufan 2017-12-15 修改批量确认
	/// sufan 2017-12-15 修改批量确认
	if(selItems.length==0){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	var mainID=""
	for(i = 0;i < selItems.length; i++)
	{
		if(selItems[i].newStatus!="完成")
		{
			$.messager.alert("提示","包含未完成状态的申请，不能进行完成确认！")
			return;	
		}
		
		var DismainID=selItems[i].mainRowID
		var TypeID=selItems[i].TypeID
		if(mainID=="")
		{
			mainID=DismainID
		}else{
			mainID=mainID +"$"+DismainID
		}
	}
	
	DisAffirmWindow(mainID,TypeID);
}
function DisAffirmWindow(mainID,TypeID)
{
	
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			iconCls:'icon-blue-edit',
			title:'评价',
			border:true,
			closed:"true",
			width:600,
			height:350,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
			onClose:function(){
				$('#win').remove();  //窗口关闭时移除win的DIV标签
			}
		});
		//iframe 定义
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disaffirm.csp?mainRowID='+mainID+'&createUser='+LgUserID+'&type='+TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//陪送确认
function exeDis(){
	if((rowDataS=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
		}
	var mainID = rowDataS.mainRowID
	var TypeID = rowDataS.TypeID
	$.messager.confirm('配送确认','确认将改陪送状态置为完成确认吗？',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":16,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("提示",data);	
						}
						else{
							$.messager.alert("提示","操作成功！");
						}
						
					},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowDataS="";
		}		
	})
}

// 撤销申请
function Undorequest(){
	
	var rowData=$("#cspAffirmStatusTb").datagrid('getSelections')
	if((rowData=="")){
			$.messager.alert("提示","请选择其中一条申请单！")
			return;	
	}
	var dataList = [];
	for(var i=0;i<rowData.length;i++)
	{
		if((rowData[i].newStatus!="待处理")&&(rowData[i].newStatus!="撤销安排")){
			$.messager.alert("提示","勾选的申请状态非待处理或撤销安排,请核实"); 
			return false;
		}
		var StatusCode=100
		var tmp=rowData[i].mainRowID +"^"+ StatusCode +"^"+ rowData[i].TypeID +"^"+ rowData[i].newStatus +"^"+ LgUserID;
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('确认','您确认要撤销该条记录吗？',function(r){
			if(r){
				runClassMethod("web.DHCDISAffirmStatus","CancelApplicaion",{'params':params},function(data){
					if(data==0){
						$.messager.alert("提示","撤销成功！");
					}
					else if(data=="-1")
					{
						$.messager.alert("提示","获取下个流程状态失败！");
					}
					else if(data=="-2")
					{
						$.messager.alert("提示","更新申请单状态失败！");
					}
					else if(data=="-3")
					{
						$.messager.alert("提示","保存操作流水表失败！");
					}else
					{
						$.messager.alert("提示","撤销失败！");
					}
				},'text',false)
				$('#cspAffirmStatusTb').datagrid('reload');
			}	
	})
}


//详情弹出层页面
function ParticularsPages(){
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	if((selItems=="")||(selItems.length>1)){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}
	
	if($('#detailswin').is(":visible")){return;}  //窗体处在打开状态,退出detailswin

	$('body').append("<div id='detailswin' class='hisui-window' title='详情' style='width:800px;height:400px;top:100px;left:260px;padding:10px'></div>");

	$('#detailswin').window({
		iconCls:'icon-paper-info',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:true,
		minimizable:false,
		maximizable:false,
		resizable:false,
		//draggable:false,
		onClose:function(){
			$('#detailswin').remove();  //窗口关闭时移除win的DIV标签
			}
	}); 

	//iframe 定义
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+selItems[0].mainRowID+'&typeID='+selItems[0].TypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');
}
///复制陪送申请
function RequestCopy()
{
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	if((selItems=="")||(selItems.length>1)){
		$.messager.alert("提示","请选择其中一条申请单！")
		return;	
	}

	$('#copyTimePanel').window({
		iconCls:'icon-copy',
		title:'复制窗口',
		collapsible:false,
		minimizable:false,
		border:false,
		closed:false,
		width:500,
		height:240
	});
			
	$('#copyTimePanel').window('open');
	InitCopyCombobox();  //初始化combobox
	GetReqMessage(selItems); //获取申请单信息
}
///初始化combobox
function InitCopyCombobox()
{
	$('#CopyRecLoc').combobox({ //接收科室    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'     
	});
	$('#CopyReqType').combobox({ //陪送类型   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#CopyReqWay').combobox({ //陪送方式 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#CopyTime').combobox({ //陪送时间 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	$('#CopyTimePart').combobox({ //陪送时间段 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	});
	///初始化陪送人员下拉框
	$('#EsCopyper').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID,
		valueField:'value',
	    textField:'text',
	    mode:'remote'
	});
}
///获取申请单信息  2017-06-02  zwq
function GetReqMessage(selItems)
{
	var ReqID=selItems[0].mainRowID;
	runClassMethod("web.DHCDISAffirmStatus","GetReqMessage",{'ReqID':ReqID},function(data){
				SetComboboxValue(data);
			},'text');
	
}
///给combobox设置原申请单默认值
function SetComboboxValue(ReqMessage)
{
	var CopyReqRecLocdr=ReqMessage.split("^")[0];
	var CopyReqWay=ReqMessage.split("^")[1];
	var CopyReqType=ReqMessage.split("^")[2];
	var CopyReqMark=ReqMessage.split("^")[3];
	if(CopyReqRecLocdr=="")
	{
		$('#CopyRecLoc').combobox({disabled:true});
	}
	else
	{
		$('#CopyRecLoc').combobox('setValue',CopyReqRecLocdr);
	}
	$('#CopyReqWay').combobox('setValue',CopyReqWay);
	$('#CopyReqType').combobox('setValue',CopyReqType);
	$('#CopyNote').val(CopyReqMark);
}
///确认复制陪送申请
function SureRequestCopy(){
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	var ReqID=selItems[0].mainRowID
	var ReqRecLoc=selItems[0].acceptLoc
	var CopyReqRecLoc=$('#CopyRecLoc').combobox('getValue');//接收科室
	var CopyReqDate=$('#CopyStartDate').combobox('getValue'); //陪送日期
	var CopyReqWay=$('#CopyReqWay').combobox('getValue');
	var ReqWayText=$('#CopyReqWay').combobox('getText');
	var CopyReqTimePoint=$('#CopyTime').combobox('getText');
	var CopyReqTimeValue=$('#CopyTime').combobox('getValue')
	var CopyReqType=$('#CopyReqType').combobox('getValue');
	var ReqTypeText=$('#CopyReqType').combobox('getText');
	//var CopyReqTime=$('#CopyTime').combobox('getText')
	var CopyReqTime=""
	var CopyReqNote=$('#CopyNote').val();
	CopyReqNote = CopyReqNote.replace(/\^/g,'');
	var CopyNum=1
	CopyDate=CopyReqDate+" "+CopyReqTime+" "+CopyReqTimePoint;

	var DateFlag=serverCall("web.DHCDISRequest","JudgeDate",{"Date":CopyReqDate})
	var TimeFlag=serverCall("web.DHCDISRequest","JudgeTime",{"Date":CopyReqDate,"Time":CopyReqTimePoint})
	var ReqTypeText=$('#CopyReqType').combobox('getText');
	var ReqWayText=$('#CopyReqWay').combobox('getText');
	var EsCopyper=$("#EsCopyper").combobox('getValue');
	var EsCopyperText=$("#EsCopyper").combobox('getText');
	if(CopyReqDate=="")
	{
		$.messager.alert("提示:","请选择陪送日期!");
		return false;
	}
	if((DateFlag==0)&&(LocDesc.indexOf("陪送中心") ==-1)){
		$.messager.alert("提示:","陪送日期小于当前日期!");
		return false;
	}
	if(CopyReqTimePoint=="")
	{
		$.messager.alert("提示:","请选择陪送时间!");
		return false;
	}
	if(CopyReqTimeValue==undefined)
	{
		$.messager.alert("提示:","陪送时间格式有误,请选择陪送时间!");
		return false;
	}
	if((TimeFlag==0)&&(LocDesc.indexOf("陪送中心") =="-1")){
	$.messager.alert("提示:","陪送时间小于当前时间!");
		return false;
	}
	if((CopyReqWay=="")||(ReqWayText==""))
	{
		$.messager.alert("提示:","请选择陪送方式!");
		return false;
	}
	if(CopyReqWay==undefined)
	{
		$.messager.alert("提示:","陪送方式数据有误,请选择陪送方式!");
		return false;
	}
	if((CopyReqType=="")||(ReqTypeText==""))
	{
		$.messager.alert("提示:","请选择陪送类型!");
		return false;
	}
	if(CopyReqType==undefined)
	{
		$.messager.alert("提示:","陪送类型数据有误,请选择陪送类型!");
		return false;
	}
	if((ReqRecLoc!="")&&(CopyReqRecLoc==""))
	{
		$.messager.alert("提示:","请选择接收科室!");
		return false;
	}
	if(((EsCopyper=="")||(EsCopyperText==""))&&(LocDesc.indexOf("陪送中心") !="-1"))
	{
		$.messager.alert("提示:","请选择陪送人员!");
		return false;
	}
	
	var CopyStr=CopyReqRecLoc+"^"+CopyDate+"^"+CopyReqType+"^"+CopyReqWay+"^"+CopyNum+"^"+CopyReqNote+"^"+LgCtLocID+"^"+LgUserID
	runClassMethod("web.DHCDISAffirmStatus","RequestCopy",{'reqID':ReqID,'copyStr':CopyStr},function(data){
				if(data>0){
					$.messager.alert("提示","复制成功!");
					
					AutoArrangement(data,EsCopyper);
					$('#copyTimePanel').window('close');
					$('#cspAffirmStatusTb').datagrid('reload')
					
					
				}
				else{
					$.messager.alert("提示","复制失败!");
				}
				
			},'text');
			rowDataS=="";
		
}

///sufan 2017-11-29 复制窗口取消事件
function CancleRequestCopy()
{
	$('#copyTimePanel').window('close');
}
///自动安排方法  sufan 2017-11-28，增加自动安排的方法
function AutoArrangement(RepID,EscortPer)
{
	var StatusCode="11";
	runClassMethod("web.DHCDISRequest","AutoArrangement",{'RepID':RepID,'StatusCode':StatusCode,'OperID':UserID,'RepLoc':LgCtLocID,'EscortPerID':EscortPer},function(data){

	},'text',false)
}
///sufan 2018-01-02
function initPatList()
{
	//患者列表
	// 定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'登记号',width:100,hidden:true},
		{field:'PatName',title:'姓名',width:100,hidden:true},
		{field:'PatBed',title:'床号',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'性别',width:100,hidden:true},
		{field:'Adm',title:'就诊ID',width:100,hidden:true},
	]];
	var LocID=$('#VisLoc').combobox("getValue")	///sufan 2018-01-02  将后台的session改为js传值
	//var Str=LocID +"^"+ "" +"^"+ "" +"^"+ "";	
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=SelByAdm&SelByAdm="+SelByAdm+"&LocID="+LocID,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  // 每页显示的记录条数
		pageList:[200,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    pagination:true,
		loadMsg: '正在加载信息...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        PatAdm=rowData.Adm ;   //sufan 2017-12-03
	        clearForm();//清空form表单
	        setForm(rowData);//赋值form表单
	        rewTbUrl(rowData);//table重写url
	        selAdmReq(rowData);//查找对应患者申请单
	        requested=0;//区分是否已申请
	    },
		onLoadSuccess:function(data){
			// 隐藏分页图标
            //$('#List .pagination-page-list').hide();
            var rows = $("#DisReqPatTb").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].Adm==PatAdm)
	            {
		            $('#DisReqPatTb').datagrid('selectRow',i);
		            clearForm();//清空form表单
	        		setForm(rows[i]);//赋值form表单
	        		rewTbUrl(rows[i]);//table重写url
	        		selAdmReq(rows[i]);//查找对应患者申请单
	        		requested=0;//区分是否已申请
				}
	         }
            $('#List .pagination-info').hide();
            
            
		}
	});
	//隐藏刷新
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false}); 
	/*//患者列表
	// 定义columns
	var columns=[[
		{field:'PatLabel',title:'预检分诊',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'登记号',width:100,hidden:true},
		{field:'PatName',title:'姓名',width:100,hidden:true},
		{field:'PatBed',title:'床号',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'性别',width:100,hidden:true},
		{field:'Adm',title:'就诊ID',width:100,hidden:true},
	]];
	var LocID=$('#VisLoc').combobox("getValue");
	var Str=LocID +"^"+ "" +"^"+ "" +"^"+ "";
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=getPatListByLoc&Str="+Str,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  		// 每页显示的记录条数
		pageList:[200,300],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    pagination:true,
		loadMsg: '正在加载信息...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        clearForm();			//清空form表单
	        setForm(rowData);		//赋值form表单
	        rewTbUrl(rowData);		//table重写url
	        selAdmReq(rowData);		//查找对应患者申请单
	        requested=0;			//区分是否已申请
	        PatAdm=rowData.Adm;	 	///sufan 2017-12-21  患者就诊号
	        //alert(PatAdm)
	    },
		onLoadSuccess:function(data){
			// 隐藏分页图标
            $('#List .pagination-info').hide();
		}
	});
	//隐藏刷新
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false});*/
	
}
function initPatform()
{
	$('#VisLoc').combobox({ //就诊科室    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote',
    	onSelect:function(option){
	        //GetSearchInfo();
	    }     
	});
	//$('#VisLoc').combobox("setValue","216")
	$('#RecLoc').combobox({ //接收科室    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(){
	    	var Othsel=$("#DisReqOthTb").datagrid('getSelections');
	    	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	    	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	    	if(len==0)
	    	{
				if(lenOth==0)
	    		{
		    		$('#RecLoc').combobox('setValue',"");
		    		$.messager.alert("提示:","请先选择其他项目!");
		    		return;
		    	}else if(Othsel[0].RecLocFlag!="Y")
		    		{
			    		 $('#RecLoc').combobox('setValue',"");
			    	}
		    }
		    else
		    {
			   $('#RecLoc').combobox('setValue',"");
		    	return; 
			}
	    }
    
	});  
	$('#ReqType').combobox({ //陪送类型   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#ReqWay').combobox({ //陪送方式 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#Time').combobox({ //陪送时间 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	/*$('#ReqNum').combobox({ //陪送人数   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",    
	    valueField:'id',    
	    textField:'text',
	    onSelect: function () {
				//获取选中的值
				var varSelect = $(this).combobox('getValue');
				runClassMethod("web.DHCDISRequest","GetNowReqNum",
			    {Loc:varSelect},
				function(data){
					if(data<varSelect){
						$.messager.alert("提示","当前空闲人数为 "+data+" 人!");
					}
				});	
								
		}  
	});*/
}
///隐藏/显示部分控件
function hideControl()
{	
	if($('#Adm').is(':checked')){
		$("#AdmLoc").hide();   		//就诊科室
		$("#AdmDate").hide();   	//就诊日期
		$("#PatName").hide();   	//患者姓名
		$("#PatRegNo").hide();  	//登记号
		$("#SearStDate").show();    //开始日期
		$("#SearEndDate").show();   //结束日期
		$("#SeaPatNo").show();		//登记号
		$("#VisLoc").combobox("setValue","");   	//就诊科室
		$("#VisDate").datebox("setValue","");   	//就诊日期
		$("#AdmName").val("");   	//患者姓名
		$("#PatNo").val("");  	//登记号
		$("#VisLoc").combobox("hidePanel");
		$("#VisDate").datebox("hidePanel");
		
	}else{
		$("#AdmLoc").show();   		//就诊科室
		$("#AdmDate").show();   	//就诊日期
		$("#PatName").show();   	//患者姓名
		$("#PatRegNo").show();  	//登记号
		$("#SearStDate").hide();    //开始日期
		$("#SearEndDate").hide();   //结束日期
		$("#SeaPatNo").hide();		//登记号
		$("#PatNoSearch").val("");
		$("#StDate").datebox("hidePanel");
		$("#EndDate").datebox("hidePanel");
		$("#StDate").datebox("setValue",formatDate(0));	 	 ///开始日期
		$("#EndDate").datebox("setValue",formatDate(0));	 ///结束日期
		
	}
	$("#StDate").datebox("setValue",formatDate(0));	 	 ///开始日期
	$("#EndDate").datebox("setValue",formatDate(0));	 ///结束日期
}