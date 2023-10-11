/**
 * 医保科室信息JS
 * FileName: insulocrecinfo.js
 * DingSH 2018-10-18
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 var InLocRowid="";
 var InLocRecRowid="";
 var UpFlag ="";
 var HospDr='';
 var GUser=session['LOGON.USERID'];
 var LocRowIndex=-1;
 var LocRecRowIndex=-1;
 $(function()
 {
	$(document).keydown(function (e) {
		banBackSpace(e);
	}); 
	//#1初始化医保类型	
	InitInsuTypeCmb()	
	//#2初始化医保科室gd
	InitInLocDg()
		 
	//#3初始化医保科室记录gd
	InitInLocRecDg()

	//#4初始化Btn事件
	InitBtnClick();   
	  
	//#5隐藏元素
	 $('#locDlEd').hide();
	 $('#locRecDlEd').hide();     
	 $('#locRecDlBd').hide();            
  	QryInLoc();	
});

//初始化Btn事件
function InitBtnClick(){
	
	
	//关键字回车事件
	$("#KeyWords").keydown(function(e) { 
	KeyWords_onkeydown(e);
	});  
	
	//科室信息编辑框 保存按钮事件
	 $("#btnS").click(function () {
	        UpdateInLoc();
            QryInLoc();
			
        });
    //科室信息编辑框 关闭按钮事件    
   $("#btnC").click(function () {
            //QryInLoc();
			$('#locDlEd').window('close');  
       });       
    //科室信息上传编辑框 保存按钮事件              
        
  $("#btnS1").click(function () {
            //QryInLoc();
            UpdateInLocRec();
            QryInLocRec();
        });
      //科室信息上传编辑框 关闭按钮事件   
   $("#btnC1").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlEd').window('close');  
       });  
     //上传记录生成框 生成按钮事件  
    $("#btnRbd").click(function () {
            ReBuildInLocRec();
        });
        //上传记录生成框 关闭按钮事件  
   $("#btnRbC").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlBd').window('close');  
       });     
        
	
	}

//关键字回车事件
function KeyWords_onkeydown(e)
{
	if (e.keyCode==13)
	{
		QryInLoc();
		
	}
}

//查询科室信息事件
function QryInLoc()
{	
    //var stdate=$('#stdate').datebox('getValue');
	//var endate=$('#endate').datebox('getValue');
    var InRowid=""
    var KeyWords=$('#KeyWords').val();
	$('#locdg').datagrid('reload',{
		ClassName:'web.DHCINSULocInfoCtl',
		QueryName:'QryInLocInfo',
		InRowid:InRowid,
		KeyWords:KeyWords,
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	});
	
}



//查询医保科室上传记录事件
function QryInLocRec()
{
    var InRowid=""
    var InsuType=$('#InsuType').combobox("getValue")
    //alert("InLocRowid="+InLocRowid)
       $('#locrecdg').datagrid('options').url = $URL
	   $('#locrecdg').datagrid('reload',{
		ClassName:'web.DHCINSULocRecCtl',
		QueryName:'QryInLocRecInfo',
		InLocRowid:InLocRowid,
		InsuType:InsuType,
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
		});
	
	
}

//初始化医保类型
function InitInsuTypeCmb()
{
	//初始化combobox
	$HUI.combobox("#InsuType",{
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	onSelect: function(rec)
    	{
	      QryInLocRec();
	    	
	    },
	    onLoadSuccess:function(){
			$('#InsuType').combobox('select','00A');
			},
	});
	var comboJson=$.cm({
	    ClassName:"web.INSUDicDataCom",
	    QueryName:"QueryDic",
	    Type:"DLLType",
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
	    Code:""
	 },false)
	$HUI.combobox("#InsuType").loadData(comboJson.rows)
	
	}

//初始化医保科室gd
function InitInLocDg()
{
	$HUI.datagrid("#locdg",{
		url:$URL,
		fit: true,
		border: false,
		striped:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'操作',
		    formatter: function (value, row, index) {
				return "<img class='myTooltip' style='width:60' title='科室信息修改' onclick=\"locEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
			}
		  },{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TDeptCode',title:'医院科室编码',width:140},
			{field:'TDeptDesc',title:'医院科室名称',width:180},
			{field:'TDeptType',title:'科室类型',width:150,hidden:true},
			{field:'TStandDeptCode',title:'国家科室名称',width:120},
			{field:'TProfessionDeptCode',title:'国家科室代码 ',width:120},
			{field:'TDeptDr',title:'HIS科室id',width:50,align:'center',hidden:true}
		]],
		columns:[[
			{field:'TSPBedNum',title:'批准床位数量',width:100},
			{field:'TSJBedNum',title:'医保认可床位数量',width:120},
			{field:'TDeptSetUpDate',title:'科室成立时间',width:100},
			{field:'TDoctorNum',title:'医师人数',width:80},
			{field:'TTechnicianNum',title:'技师人数',width:80},
			{field:'TPharmacistNum',title:'药师人数',width:80},
			{field:'TNurseNum',title:'护士人数',width:80},
			{field:'TDeptHead',title:'科室负责人',width:120},
			{field:'TDeptHeadTelNo',title:'科室负责人电话',width:120},
			{field:'Titro',title:'简介',width:120},
			{field:'Tmedservscp',title:'医疗服务范围',width:120},
			{field:'Tpoolareano',title:'统筹区编号',width:100},
			{field:'THospCode',title:'医院机构编码',width:50,hidden:true},
			{field:'TStDate',title:'开始日期',width:100},
			{field:'TStTime',title:'开始时间',width:50,hidden:true},
			{field:'TEdDate',title:'结束日期',width:100},
			{field:'TEdTime',title:'结束时间',width:50,hidden:true},
			{field:'TActFlag',title:'有效标志',width:50,hidden:true},
			{field:'TUserDr',title:'经办人',width:100,hidden:true},
			{field:'TUserName',title:'经办人',width:100},
			{field:'TDate',title:'经办日期',width:140},
			{field:'TTime',title:'经办时间',width:140},
			{field:'TRemark',title:'备注',width:50},
			{field:'TExtStr01',title:'扩展01',width:50,hidden:true},
			{field:'TExtStr02',title:'扩展03',width:50,hidden:true},
			{field:'TExtStr03',title:'扩展03',width:50,hidden:true},
			{field:'TExtStr04',title:'扩展04',width:50,hidden:true},
			{field:'TExtStr05',title:'扩展05',width:50,hidden:true}
			
		]],
		pageSize: 10,
		pageList:[10,20,30],
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
			InLocRowid=rowData.TRowid;
			QryInLocRec();
        },
        onDblClickRow:function(rowIndex, rowData){
	        //initLocFrm(rowIndex, rowData);
	        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess:function(data)
		{
			LocRowIndex=-1;
		}
	});	
}
//初始化医保科室记录gd
function InitInLocRecDg()
{
	 //初始化datagrid
	$HUI.datagrid("#locrecdg",{
		///idField:'recdgid',
		//rownumbers:true,
		url:$URL,
		fit:true,
		striped:true,
		singleSelect: true,
		modal:true,
		border:false,
		data: [],
		frozenColumns:[[
		  { 
		    field:'TOpt1',
		    width:40,
		    title:'操作',
		    formatter: function (value, row, index) {
						
							return "<img class='myTooltip' style='width:60' title='上传记录修改' onclick=\"locRecEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";
						
					}
		  }
		
		]],
		columns:[[
			{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TCTDr',title:'医保科室信息指针',width:60,hidden:true},
			{field:'TCenterNo',title:'统筹区编码',width:100},
			{field:'TStates',title:'行政区代码',width:100},
			{field:'TSeriNo',title:'申请流水号',width:100},
			{field:'TBusiNo',title:'发送方交易流水号',width:150,hidden:true},
			{field:'TInsuType',title:'医保类型',width:80,hidden:true},
			{field:'TInsuTypeDesc',title:'医保类型',width:80,align:'left'},
			{field:'THSPUserDr',title:'医院审批人',width:60,hidden:true},
			{field:'THSPUserCode',title:'医院审批人',width:60,hidden:true},
			{field:'THSPUserName',title:'医院审批人',width:120},
			{field:'THSPFlag',title:'科室上传状态',width:140},
			{field:'THSPDate',title:'科室上传日期',width:140},
			{field:'THSPTime',title:'科室上传时间',width:140},
			{field:'TISPUserDr',title:'上传人',width:140,hidden:true},
			{field:'TISPFlag',title:'医保审批状态',width:140},
			{field:'TISPDate',title:'医保审批日期',width:140},
			{field:'TISPTime',title:'医保审批时间',width:140},
			{field:'TUserDr',title:'经办人',width:60,hidden:true},
			{field:'TUserCode',title:'经办人',width:60,hidden:true},
			{field:'TUserName',title:'经办人',width:100},
			{field:'TDate',title:'经办日期',width:150},
			{field:'TTime',title:'经办时间',width:150},
			{field:'TExtStr01',title:'扩展01',width:50,hidden:true},
			{field:'TExtStr02',title:'扩展03',width:50,hidden:true},
			{field:'TExtStr03',title:'扩展03',width:50,hidden:true},
			{field:'TExtStr04',title:'扩展04',width:50,hidden:true},
			{field:'TExtStr05',title:'扩展05',width:50,hidden:true}
			
		]],
		pageSize: 10,
		pagination:true,
		//rownumbers:true,
        onClickRow:function(rowIndex, rowData) {
	      InLocRecRowid=rowData.TRowid;
	      UpFlag=rowData.THSPFlag
        },
         onDblClickRow:function(rowIndex, rowData){
	       
	        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess:function(data)
		{
			var index=0;
			if (data.total>0)
			{
			if (LocRecRowIndex>=0){
			   index=LocRecRowIndex
			 }
			$('#locrecdg').datagrid('selectRow',index);
			}
			LocRecRowIndex=-1; 

		}
	});
	

	
}

//加载科室信息
function loadLocPanel(rowIndex, rowData)
{

	$HUI.combobox('#ActFlag', {
		panelHeight: 'auto',
		data: [ {
				value: '1',
				text: '有效'
			},{
				value: '0',
				text: '无效'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	
	
	$HUI.combobox('#DeptType', {
		panelHeight: 'auto',
		data: [ {
				value: '1',
				text: '门诊'
			},{
				value: '2',
				text: '住院'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	$("#StandDeptCode").combogrid({
		panelWidth: 320,
		panelHeight: 350,
		mode:'remote',
		delay:300,
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'cCode',
		textField: 'cDesc',
		//url:$URL,
		data:[],
		columns:[
		[{
			field:'id',title:'rowid',hidden:true},
			{field:'cCode',title:'编码',width:100} ,
			{field:'cDesc',title:'名称',width:100},
		]],
		onBeforeLoad:function(param){
				$('#StandDeptCode').combogrid("grid").datagrid("options").url=$URL;
				param.ClassName="web.INSUDicDataCom";
				param.QueryName="QueryDic";
				param.Type="dept00A";
				param.Code=param.q;
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){
			setValueById('ProfessionDeptCode',rowData.cCode);		
			}	
	})
	$("#DeptHead").combogrid({
		panelWidth: 320,
		panelHeight: 350,
		mode:'remote',
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'Description',
		textField: 'Description',
		url:$URL,
		data:[],
		columns:[
		[{
			field:'HIDDEN',title:'HIDDEN',hidden:true},
			{field:'Code',title:'编码',width:100} ,
			{field:'Description',title:'名称',width:100},
		]],
		onBeforeLoad:function(param){
			param.ClassName = "web.SSUser";
			param.QueryName= "LookUpActive";
			param.desc = param.q;
			//param.Code=param.q
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){	 
			}	
	})
	setValueById('DeptCode',rowData.TDeptCode)
	setValueById('DeptDesc',rowData.TDeptDesc)
	setValueById('DeptType',rowData.TDeptType)
	setValueById('StandDeptCode',rowData.TStandDeptCode)
	setValueById('ProfessionDeptCode',rowData.TProfessionDeptCode)
	setValueById('DeptDr',rowData.TDeptDr)
	setValueById('SPBedNum',rowData.TSPBedNum)
	setValueById('SJBedNum',rowData.TSJBedNum)
	setValueById('DeptSetUpDate',rowData.TDeptSetUpDate)
	setValueById('DoctorNum',rowData.TDoctorNum)
	setValueById('TechnicianNum',rowData.TTechnicianNum)
	setValueById('PharmacistNum',rowData.TPharmacistNum)
	setValueById('NurseNum',rowData.TNurseNum)
	setValueById('DeptHead',rowData.TDeptHead)
	setValueById('DeptHeadTelNo',rowData.TDeptHeadTelNo)
	setValueById('StDate',rowData.TStDate)
	setValueById('EdDate',rowData.TEdDate)
	setValueById('ActFlag',rowData.TActFlag)
	$('#UserDr').val(rowData.TUserDr)
	$('#UserName').val(rowData.TUserName)
	setValueById('Date',rowData.TDate)
	$('#Time').val(rowData.TTime)
	$('#Remark').val(rowData.TRemark)
//	$('#ExtStr01').val(rowData.TExtStr01)
//	$('#ExtStr02').val(rowData.TExtStr02)
//	$('#ExtStr03').val(rowData.TExtStr03)
//	$('#ExtStr04').val(rowData.TExtStr04)
//	$('#ExtStr05').val(rowData.TExtStr05)
//	$('#Remark').val(rowData.TRemark)
	$('#itro').val(rowData.Titro)
	$('#medservscp').val(rowData.Tmedservscp)
	$('#Rowid').val(rowData.TRowid)
	$('#HospCode').val(rowData.THospCode)

}

function  locEditClick(rowIndex){
	LocRowIndex=rowIndex;
	var rowData=$('#locdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	initLocFrm(rowIndex,rowData)
	}

//初始化科室编辑框
function initLocFrm(rowIndex, rowData)
{      
    loadLocPanel(rowIndex, rowData);
    $('#locDlEd').show(); 
		$HUI.dialog("#locDlEd",{
			title:"科室信息编辑",
			height:510,
			width:850,
		    iconCls: 'icon-w-edit',
			modal:true
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'保存',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("修改成功,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}

//加载科室信息
function loadLocRecPanel(rowIndex, rowData)
{
	$HUI.combobox('#RHSPFlag', {
		panelHeight: 'auto',
		data: [{
				value: '',
				text: '未上传',
				'selected':true
			}, {
				value: '1',
				text: '已上传'
			},{
				value: '2',
				text: '已变更'
			},{
				value: '0',
				text: '已撤销'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	$('#RCTDr').val(rowData.TCTDr);
	$('#RCenterNo').val(rowData.TCenterNo);
	$('#RStates').val(rowData.TStates);
	$('#RSeriNo').val(rowData.TSeriNo);
	$('#RBusiNo').val(rowData.TBusiNo);
	$('#RInsuType').val(rowData.TInsuType);
	$('#RInsuTypeDesc').val(rowData.TInsuTypeDesc);
	$('#RHSPUserName').val(rowData.THSPUserName);
	$('#RHSPUserDr').val(rowData.THSPUserDr);
	//$('#RHSPFlag').val(rowData.THSPFlag);
	setValueById('RHSPFlag',rowData.THSPFlag)
	//$('#RHSPDate').val(rowData.THSPDate);
	setValueById('RHSPDate',rowData.THSPDate)
	$('#RHSPTime').val(rowData.THSPTime);
	$('#RISPUserDr').val(rowData.TISPUserDr);
	$('#RISPFlag').val(rowData.TISPFlag);
	//$('#RISPDate').val(rowData.TISPDate);
	setValueById('RISPDate',rowData.TISPDate)
	$('#RISPTime').val(rowData.TISPTime);
	$('#RUserDr').val(rowData.TUserDr);
	$('#RUserName').val(rowData.TUserName);
	//$('#RDate').val(rowData.TDate);
	setValueById('RDate',rowData.TDate)
	$('#RTime').val(rowData.TTime);
	$('#RExtStr01').val(rowData.TExtStr01);
	$('#RExtStr02').val(rowData.TExtStr02);
	$('#RExtStr03').val(rowData.TExtStr03);
	$('#RExtStr04').val(rowData.TExtStr04);
	$('#TExtStr05').val(rowData.TExtStr05);
	$('#RRowid').val(rowData.TRowid);
}	
	
	
function  locRecEditClick(rowIndex){
	LocRecRowIndex=rowIndex;
	var rowData=$('#locrecdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	initLocRecFrm(rowIndex,rowData)
	
	}	
	
	
//初始化医保上传记录编辑框
function initLocRecFrm(rowIndex, rowData)
{       
    loadLocRecPanel(rowIndex, rowData);
    $('#locRecDlEd').show(); 
		$HUI.dialog("#locRecDlEd",{
			title:"医保上传记录编辑",
			height:320,
			width:880,
			iconCls:'icon-w-edit',
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'保存',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("修改成功,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}


//保存科室信息
function UpdateInLoc()
{
	var InStr=BuildInLoc();
	//alert("InStr="+InStr)
	//var rtn=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",InStr)
		$.m({
			  ClassName:"web.DHCINSULocInfoCtl",
			  MethodName:"Save",
			  InString:InStr
			  },
			  function(rtn){
			if(eval(rtn.split("^")[0])>0)
			  {
	                  $.messager.alert("提示", "保存成功", 'info');  
	           }else{
		              $.messager.alert("提示", "保存失败"+rtn, 'info');  
	                }
			$('#locDlEd').window('close');  
		});		
	
}
//获取待保存科室信息串
function BuildInLoc()
{
	var InStr=getValueById('Rowid')                    // getValueById('Rowid')
	InStr=InStr+"^"+getValueById('DeptCode')           // getValueById('DeptCode')
	InStr=InStr+"^"+getValueById('DeptDesc')           // getValueById('DeptDesc')
	var type=getValueById('DeptType')
	if(type=="门诊"){type="1"}else{type="2"}
	InStr=InStr+"^"+type           // getValueById('DeptType')
	InStr=InStr+"^"+getValueById('StandDeptCode')      // getValueById('StandDeptCode')
	//InStr=InStr+"^"+getValueById('ProfessionDeptCode') // getValueById('ProfessionDeptCode')
	var ProfessionDeptCode=getValueById('ProfessionDeptCode');
	if(ProfessionDeptCode == "")
	{
		$.messager.alert("温馨提示","科别不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+ProfessionDeptCode
	InStr=InStr+"^"+getValueById('DeptDr')         // getValueById('DeptDr')
	InStr=InStr+"^"+getValueById('SPBedNum')       // getValueById('SPBedNum')
	InStr=InStr+"^"+getValueById('SJBedNum')  // getValueById('SJBedNum')
	//InStr=InStr+"^"+getValueById('DeptSetUpDate')     // getValueById('DeptSetUpDate')
	var DeptSetUpDate=getValueById('DeptSetUpDate');
	if(DeptSetUpDate == "")
	{
		$.messager.alert("温馨提示","科室成立日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptSetUpDate
	InStr=InStr+"^"+getValueById('DoctorNum')      // getValueById('DoctorNum')
	InStr=InStr+"^"+getValueById('TechnicianNum')  // getValueById('TechnicianNum')
	InStr=InStr+"^"+getValueById('PharmacistNum')  // getValueById('PharmacistNum')
	InStr=InStr+"^"+getValueById('NurseNum')       // getValueById('NurseNum')
	//InStr=InStr+"^"+getValueById('DeptHead')       // getValueById('DeptHead')
	var DeptHead=getValueById('DeptHead');
	if(DeptHead == "")
	{
		$.messager.alert("温馨提示","科室负责人不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptHead
	//InStr=InStr+"^"+getValueById('DeptHeadTelNo')  // getValueById('DeptHeadTelNo')
	var DeptHeadTelNo=getValueById('DeptHeadTelNo');
	if(DeptHeadTelNo == "")
	{
		$.messager.alert("温馨提示","负责人电话不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptHeadTelNo
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	//InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('HospCode')		// getValueById('HospCode')
	//InStr=InStr+"^"+getValueById('StDate')		// getValueById('StDate')
	var StDate=getValueById('StDate');
	if(StDate == "")
	{
		$.messager.alert("温馨提示","开始日期不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+StDate
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('EdDate')		// getValueById('EdDate')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('ActFlag')
	InStr=InStr+"^"+getValueById('UserDr')		// getValueById('UserDr')
	InStr=InStr+"^"+getValueById('Date')		// getValueById('Date')
	InStr=InStr+"^"+getValueById('Time')		// getValueById('Time')
	InStr=InStr+"^"+getValueById('Remark')		// getValueById('Remark')
	//InStr=InStr+"^"+getValueById('itro')		// getValueById('ExtStr01')
	var itro=getValueById('itro');
	if(itro == "")
	{
		$.messager.alert("温馨提示","简介不能为空!", 'info');
		return ;
	}
	InStr=InStr+"^"+itro						// getValueById('ExtStr01')
	//InStr=InStr+"^"+getValueById('ExtStr02'	 // getValueById('ExtStr02')
	InStr=InStr+"^"+getValueById('medservscp')	// getValueById('ExtStr02')
	InStr=InStr+"^"+getValueById('ExtStr03')	// getValueById('ExtStr03')
	InStr=InStr+"^"+getValueById('ExtStr04')	// getValueById('ExtStr04')
	InStr=InStr+"^"+getValueById('ExtStr05')	// getValueById('ExtStr05')
	InStr=InStr+"^"+session['LOGON.HOSPID']
	return InStr
}






//保存医保上传记录信息
function UpdateInLocRec()
{
	var InStr=BuildInLocRec();
		$.m({
			  ClassName:"web.DHCINSULocRecCtl",
			  MethodName:"Save",
			  InString:InStr
			  },
			  function(rtn){
			if(eval(rtn.split("^")[0])>0)
			  {
	                  $.messager.alert("提示", "保存成功", 'info');  
	           }else{
		              $.messager.alert("提示", "保存失败"+rtn, 'info');  
	                }
			$('#locRecDlEd').window('close');  
		});		
	
}
//获取待保存医保上传记录串
function BuildInLocRec()
{
	var InStr=getValueById('RRowid')              // getValueById('RRowid')
	InStr=InStr+"^"+getValueById('RCTDr')          // getValueById('RCTDr')
	InStr=InStr+"^"+getValueById('RCenterNo')     // getValueById('RCenterNo')
	InStr=InStr+"^"+getValueById('RStates')        // getValueById('RStates')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('RInsuType')      // getValueById('RInsuType')
	InStr=InStr+"^"+getValueById('RHSPUserDr')     // getValueById('RHSPUserDr')
	InStr=InStr+"^"+getValueById('RHSPFlag')       // getValueById('RHSPFlag')
	InStr=InStr+"^"+getValueById('RHSPDate')       // getValueById('RHSPDate')
	InStr=InStr+"^"+getValueById('RHSPTime')      // getValueById('RHSPTime')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('RUserDr')       // getValueById('RUserDr')
	InStr=InStr+"^"+getValueById('RDate')          // getValueById('RDate')
	InStr=InStr+"^"+getValueById('RTime')          // getValueById('RTime')
	InStr=InStr+"^"+$('#RExtStr01').val()
	InStr=InStr+"^"+$('#RExtStr02').val()
	InStr=InStr+"^"+$('#RExtStr03').val()
	InStr=InStr+"^"+$('#RExtStr04').val()
	InStr=InStr+"^"+$('#RExtStr05').val()
	
	return InStr
}




//初始化医保上传记录生成框
function initLocRecRbFrm()
{       
    $('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    $('#RdInsuType').val($("#InsuType").combobox('getValue'));
    
    $('#locRecDlBd').show(); 
		$HUI.dialog("#locRecDlBd",{
			title:"医保上传记录生成",
			height:260,
			width:300,
			iconCls: 'icon-w-batch-add',
			modal:true
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'保存',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("修改成功,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}

function FrmRbdResShw()
{
	if (""==$("#InsuType").combobox('getValue')){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	$("#RdInsuTypeDesc").val("");
	$("#RdInsuType").val("");
	initLocRecRbFrm();

	
}



///******************************************************************
///功能说明
///生成待上传记录
function ReBuildInLocRec()
{

	var InsuTypeDesc=$("#RdInsuTypeDesc").val();
	var InsuType=$("#RdInsuType").val();
	var ExpStr=$("#RdCenter").val()+"^"+$("#RdCenter").val()+"^^^^^"
	$.messager.confirm("生成", "确定重新生成"+InsuTypeDesc+"科室上传记录?", function (r) {
		if (r)
		 {
			 $.messager.progress({
				title: "提示",
				msg: '正在同步待上传数据',
				text: '同步中....',
			    iconCls:'icon-reset'
			});
			$.m({
			  ClassName:"web.DHCINSULocRecCtl",
			  MethodName:"BuildINLocRecInfo",
			  InRowid:"",
			  InsuType:InsuType,
			  UserDr:GUser,
			  HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			  ExpStr:ExpStr
			  
			  },
			  function(rtn){
	         $.messager.alert("生成记录提示", rtn.split("!")[1], 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         //QryInLoc();
		});	
		 //setTimeout('$.messager.progress("close");', 2 * 1000);
	 } 
		
});
	
}
///******************************************************************

///******************************************************************
///功能说明：
//科室信息管理接口调用 
//科室上传3401
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var ExpStr=InsuType+"^^^3401^"+InLocRecRowid
	//alert(InLocRecRowid)
	if (InLocRecRowid==""){
		//$.messager.alert("提示", "科室上传,本次将上传所有的待上传科室记录", 'info'); 	
		}else{
			if(UpFlag=="已上传" || UpFlag=="已变更") {$.messager.alert("提示", "科室变更上传,该记录不可重复上传", 'info');return ;}
			//$.messager.alert("提示", "科室上传,本次将只上传科室上传记录表Rowid为：" +InLocRecRowid+"的数据", 'info'); 
			}
	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("提示", "科室上传失败", 'info');  
		}else{
		$.messager.alert("提示", "科室上传成功", 'info');  
	}
}
//科室变更3402
function InLocULMod()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var Rowid=InLocRecRowid;
	if(Rowid==""){$.messager.alert("提示", "科室变更失败,请选中一条上传记录", 'info');  return;}
	ExpStr=InsuType+"^^^3402^"
	if(UpFlag!="已上传" && UpFlag!="已变更") {$.messager.alert("提示", "科室变更失败,该记录尚未上传或变更,无法变更", 'info');return ;}
	var RtnFLag=InsuDicCTLocULMod(0,GUser,Rowid,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("提示", "科室变更失败", 'info');  
		}else{
		$.messager.alert("提示", "科室变更成功", 'info');  
	}
}
//科室批量上传3401A
function InLocPLUL()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var ExpStr=InsuType+"^^^3401A^"+""
	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("提示", "科室批量上传失败", 'info');  
		}else{
		$.messager.alert("提示", "科室批量上传成功", 'info');  
	}
}
//科室撤销3403
function InLocULCancel()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var Rowid=InLocRecRowid;
	if(Rowid==""){$.messager.alert("提示", "科室撤销失败,请选中一条上传记录", 'info');  return;}
	ExpStr=InsuType+"^^^3403^"
	if(UpFlag!="已上传" && UpFlag!="已变更") {$.messager.alert("提示", "科室撤销失败,该记录尚未上传或变更,无法撤销", 'info');return ;}
	var RtnFLag=InsuDicCTLocULCancel(0,GUser,Rowid,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("提示", "科室撤销失败", 'info');  
		}else{
		$.messager.alert("提示", "科室撤销成功", 'info');  
	}
}
///******************************************************************
///******************************************************************
///功能说明：
//同步科室信息 
///******************************************************************
function ReBuildInLoc()
{	
var InsuType=$("#InsuType").combobox('getValue');
$.messager.confirm("生成", "确定重新同步科室信息?", function (r) {
		if (r)
		 {
			$.messager.progress({
				title: "提示",
				msg: '正在同步科室数据',
				text: '同步中....',
			    iconCls:'icon-reset'
			});
			$.m({
			  ClassName:"web.DHCINSULocInfoCtl",
			  MethodName:"SynBuildINLocInfo",
			  InRowid:"",
			  LocCode:"",
			  LocDesc:"",
			  UserDr:GUser,
			  HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			  ExpStr:"^^^^^",
			  InsuType:InsuType
			  },
			  function(rtn){
			
	         $.messager.alert("提示", rtn.split("!")[1], 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         QryInLoc();
		});	
		
		
	 } 
		
});

			
	
}

/*
//科室上传
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid

	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	}
*/
//科室下载
function InLocDL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid
	var RtnFLag=InsuDicCTLocDL(0,GUser,ExpStr); //DHCINSUPort.js
	}

//科室导入
function InLocImpt()
{

			
			importDiag();
			
			
			
}


///******************************************************************
///功能说明：
///          数据导入
///******************************************************************
function importDiag()
{
	try{
		
	   //var fd = new ActiveXObject("MSComDlg.CommonDialog");
      // fd.Filter = "*.xls"; //过滤文件类别
      //fd.FilterIndex = 2;
      //fd.MaxFileSize = 128;
	 //fd.ShowSave();//如果是需要打开的话，就要用fd.ShowOpen();
    //fd.ShowOpen();
    //filePath=fd.filename;//fd.filename是用户的选择路径
   var filePath="";
	filePath=FileOpenWindow();
	
	$.messager.progress({
				title: "提示",
				msg: '正在导入科室数据',
				text: '导入中....'
			}
			);
			
			
			
   if(filePath=="")
    {
	   $.messager.alert('提示','请选择文件！','info')
	    return ;
     }
   
   
    
    var ErrMsg="";     //错误数据
    var errRowNums=0;  //错误行数
    var sucRowNums=0;  //导入成功的行数
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;

	try{

		for(i=2;i<=rows;i++){
			var pym="";
			var UpdateStr=buildImportStr(xlsheet,i);
			var savecode=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
				
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			setTimeout('$.messager.progress("close");', 1 * 1000);
			$.messager.alert('提示','数据正确导入完成','info');
		}else{
			setTimeout('$.messager.progress("close");', 1 * 1000);
			var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
			tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
			$.messager.alert('报错提示',tmpErrMsg,'error');   
		}
	}
	catch(e){
		$.messager.alert('报错提示',"导入时发生异常0：ErrInfo："+e.message,'info');  
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}
	
 }
catch(e){
	$.messager.alert('提示',"导入时发生异常1："+e.message);
	
}
finally{
	setTimeout('$.messager.progress("close");', 1 * 1000);
}    
   
}
function buildImportStr(xlsheet,rowindex){
	var tmpVal="";
	
	//Rowid^科室代码^科室名称^科室类型^标准科室代码^专业科室代码^科室Dr^审批床位数^实际床位数^科室成立时间^医师数据^技师数量^药师数量^护师数量^科室负责人^科室负责人电话^病区护士长^病区护士长电话^是否重点科室^重点科室等级^科室是否发生费用^医院机构编码^开始日期^开始时间^结束日期^结束时间^有效标识^经办人Dr^经办日期^经办时间^备注^扩展01^扩展02^扩展03^扩展04^扩展05
	
	//1-5 Rowid^科室代码^科室名称^科室类型^标准科室代码^
	var updateStr="";
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,1).value);                     //分类
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,4).value);       
	//6-10 专业科室代码^科室Dr^审批床位数^实际床位数^科室成立时间^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,5).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,6).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,7).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,8).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,9).value);		//

	//11-15 医师数据^技师数量^药师数量^护师数量^科室负责人^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,10).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,11).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,12).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,13).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,14).value);		//

	//16-20 科室负责人电话^病区护士长^病区护士长电话^是否重点科室^重点科室等级^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,15).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,16).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,17).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,18).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,19).value);		//

	//21-25 科室是否发生费用^医院机构编码^开始日期^开始时间^结束日期^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,20).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,21).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,22).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,23).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,24).value);		//

	//26-30 结束时间^有效标识^经办人Dr^经办日期^经办时间^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,25).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,26).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,27).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,28).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,29).value);		//

	//31-36 备注^扩展01^扩展02^扩展03^扩展04^扩展05
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,30).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,31).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,32).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,33).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,34).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,35).value);		//
	
	return updateStr;
}
function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//科室导出
function InLocEpot()
{
	try
	{
	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"科室信息维护", //默认DHCCExcel
	ClassName:"web.DHCINSULocInfoCtl",
	QueryName:"QryInLocInfo",
	InRowid:"",
	KeyWords:$('#KeyWords').val(),
	HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "提示",
				msg: '正在导出科室数据',
				text: '导出中....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("警告",e.message);
		$.messager.progress('close');
	};
	
	
	}






function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	//alert(FilePath);
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	//alert(3233);
	var filePath=$(this).val();
	//alert("filePath="+filePath);
});
function selectHospCombHandle(){
	$('#InsuType').combobox('reload');
	//QryInLoc();
	//QryInLocRec();
}
