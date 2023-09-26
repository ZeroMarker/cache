/**
 * 医保科室信息JS
 * FileName: insulocrecinfo.js
 * DingSH 2018-10-18
 * 版本：V1.0
 * hisui版本:0.1.0
 */
 var InLocRowid="";
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
  
});

//初始化Btn事件
function InitBtnClick(){
	
	
	//关键字回车事件
	$("#KeyWords").keydown(function(e) { 
	KeyWords_onkeydown(e);
	});  
	
	
	 $("#btnS").click(function () {
	        UpdateInLoc();
            QryInLoc();
			
        });
        
   $("#btnC").click(function () {
            //QryInLoc();
			$('#locDlEd').window('close');  
       });       
        
        
  $("#btnS1").click(function () {
            //QryInLoc();
            UpdateInLocRec();
            QryInLocRec();
        });
        
   $("#btnC1").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlEd').window('close');  
       });  
       
    $("#btnRbd").click(function () {
            ReBuildInLocRec();
        });
        
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
    $('#locdg').datagrid('options').url = $URL
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
	    	
	    }
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
	 	//{field:'Security',title:'允许通过',formatter:function(value,row,index){
			//	return "<span onclick='GV.showMenuSecurityWin("+row.ID+",\""+row.Name+"\",\""+row.Caption+"\")' class='icon-security'>&nbsp;</span>";
			//}}
	 //初始化datagrid
	$HUI.datagrid("#locdg",{
		url:$URL,
		//fit: true,
		border: false,
		//idField:'dgid',
		//iconCls: 'icon-save',
		//rownumbers:true,
		width: '100%',
		striped:true,
		//fitColumns:true,
		singleSelect: true,
		//autoRowHeight:false,
		
		data: [],
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'操作',
		    formatter: function (value, row, index) {
						
							return "<img class='myTooltip' style='width:60' title='科室信息修改' onclick=\"locEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
						
					}
		  }
		
		]],
		columns:[[
		
		  
			{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TDeptCode',title:'医院科室编码',width:140},
			{field:'TDeptDesc',title:'医院科室名称',width:180},
			{field:'TDeptType',title:'科室类型',width:150},
			{field:'TStandDeptCode',title:'标准科室编码',width:140},
			{field:'TProfessionDeptCode',title:'专业科室代码 ',width:150,hidden:true},
			{field:'TDeptDr',title:'科室Dr',width:50,align:'center',hidden:true},
			{field:'TSPBedNum',title:'批准床位数量',width:50,hidden:true},
			{field:'TSJBedNum',title:'实际开放床位数量',width:50,hidden:true},
			{field:'TDeptSetUpDate',title:'科室成立时间',width:50,hidden:true},
			{field:'TDoctorNum',title:'医师数量',width:50,hidden:true},
			{field:'TTechnicianNum',title:'技师数量',width:50,hidden:true},
			{field:'TPharmacistNum',title:'药师数量',width:50,hidden:true},
			{field:'TNurseNum',title:'护理人员数量',width:50,hidden:true},
			{field:'TDeptHead',title:'科室负责人',width:120},
			{field:'TDeptHeadTelNo',title:'负责人电话',width:120},
			{field:'TNurseHead',title:'护士长',width:100},
			{field:'TNurseHeadTelNo',title:'护士长电话',width:220},
			{field:'TIsKeyDept',title:'是否重点科室',width:140},
			{field:'TKeyDeptLevel',title:'重点科室等级',width:150,hidden:true},
			{field:'TIsAllowFee',title:'该科室是否发生费用',width:150,hidden:true},
			{field:'THospCode',title:'医院机构编码',width:50,hidden:true},
			{field:'TStDate',title:'开始日期',width:50,hidden:true},
			{field:'TStTime',title:'开始时间',width:50,hidden:true},
			{field:'TEdDate',title:'结束日期',width:50,hidden:true},
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
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        
			//alert("rowData="+rowData.TRowid)   
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
			var index=0;
			if (data.total>0)
			{
			 if (LocRowIndex>=0){
			   index=LocRowIndex
			 }
			  $('#locdg').datagrid('selectRow',index);
			}
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
		width: '100%',
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
			{field:'THSPFlag',title:'医院审批状态',width:140},
			{field:'THSPDate',title:'医院审批日期',width:140},
			{field:'THSPTime',title:'医院审批时间',width:140},
			{field:'TISPUserDr',title:'医保审批人',width:140,hidden:true},
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
	$('#DeptCode').val(rowData.TDeptCode)
	$('#DeptDesc').val(rowData.TDeptDesc)
	$('#DeptType').val(rowData.TDeptType)
	$('#StandDeptCode').val(rowData.TStandDeptCode)
	$('#ProfessionDeptCode').val(rowData.TProfessionDeptCode)
	$('#DeptDr').val(rowData.TDeptDr)
	$('#SPBedNum').val(rowData.TSPBedNum)
	$('#SJBedNum').val(rowData.TSJBedNum)
	$('#DeptSetUpDate').val(rowData.TDeptSetUpDate)
	$('#DoctorNum').val(rowData.TDoctorNum)
	$('#TechnicianNum').val(rowData.TTechnicianNum)
	$('#PharmacistNum').val(rowData.TPharmacistNum)
	$('#NurseNum').val(rowData.NurseNum)
	$('#DeptHead').val(rowData.TDeptHead)
	$('#DeptHeadTelNo').val(rowData.TDeptHeadTelNo)
	$('#NurseHead').val(rowData.TNurseHead)
	$('#NurseHeadTelNo').val(rowData.TNurseHeadTelNo)
	$('#IsKeyDept').val(rowData.TIsKeyDept)
	$('#KeyDeptLevel').val(rowData.TKeyDeptLevel)
	$('#IsAllowFee').val(rowData.TIsAllowFee)
	$('#HospCode').val(rowData.THosp)
	$('#StDate').val(rowData.TStDate)
	$('#StTime').val(rowData.TStTime)
	$('#EdDate').val(rowData.TEdDate)
	$('#EdTime').val(rowData.TEdTime)
	$('#ActFlag').val(rowData.TActFlag)
	$('#UserDr').val(rowData.TUserDr)
	$('#UserName').val(rowData.TUserName)
	$('#Date').val(rowData.TDate)
	$('#Time').val(rowData.TTime)
	$('#Remark').val(rowData.TRemark)
	$('#ExtStr01').val(rowData.TExtStr01)
	$('#ExtStr02').val(rowData.TExtStr02)
	$('#ExtStr03').val(rowData.TExtStr03)
	$('#ExtStr04').val(rowData.TExtStr04)
	$('#ExtStr05').val(rowData.TExtStr05)
	$('#Rowid').val(rowData.TRowid)

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
			height:550,
			width:870,
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
	$('#RCTDr').val(rowData.TCTDr);
	$('#RCenterNo').val(rowData.TCenterNo);
	$('#RStates').val(rowData.TStates);
	$('#RSeriNo').val(rowData.TSeriNo);
	$('#RBusiNo').val(rowData.TBusiNo);
	$('#RInsuType').val(rowData.TInsuType);
	$('#RInsuTypeDesc').val(rowData.TInsuTypeDesc);
	$('#RHSPUserName').val(rowData.THSPUserName);
	$('#RHSPUserDr').val(rowData.THSPUserDr);
	$('#RHSPFlag').val(rowData.THSPFlag);
	$('#RHSPDate').val(rowData.THSPDate);
	$('#RHSPTime').val(rowData.THSPTime);
	$('#RISPUserDr').val(rowData.TISPUserDr);
	$('#RISPFlag').val(rowData.TISPFlag);
	$('#RISPDate').val(rowData.TISPDate);
	$('#RISPTime').val(rowData.TISPTime);
	$('#RUserDr').val(rowData.TUserDr);
	$('#RUserName').val(rowData.TUserName);
	$('#RDate').val(rowData.TDate);
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
			height:465,
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
	var InStr=$('#Rowid').val()
	InStr=InStr+"^"+$('#DeptCode').val()
	InStr=InStr+"^"+$('#DeptDesc').val()
	InStr=InStr+"^"+$('#DeptType').val()
	InStr=InStr+"^"+$('#StandDeptCode').val()
	InStr=InStr+"^"+$('#ProfessionDeptCode').val()
	InStr=InStr+"^"+$('#DeptDr').val()
	InStr=InStr+"^"+$('#SPBedNum').val()
	InStr=InStr+"^"+$('#SJBedNum').val()
	InStr=InStr+"^"+$('#DeptSetUpDate').val()
	InStr=InStr+"^"+$('#DoctorNum').val()
	InStr=InStr+"^"+$('#TechnicianNum').val()
	InStr=InStr+"^"+$('#PharmacistNum').val()
	InStr=InStr+"^"+$('#NurseNum').val()
	InStr=InStr+"^"+$('#DeptHead').val()
	InStr=InStr+"^"+$('#DeptHeadTelNo').val()
	InStr=InStr+"^"+$('#NurseHead').val()
	InStr=InStr+"^"+$('#NurseHeadTelNo').val()
	InStr=InStr+"^"+$('#IsKeyDept').val()
	InStr=InStr+"^"+$('#KeyDeptLevel').val()
	InStr=InStr+"^"+$('#IsAllowFee').val()
	InStr=InStr+"^"+$('#HospCode').val()
	InStr=InStr+"^"+$('#StDate').val()
	InStr=InStr+"^"+$('#StTime').val()
	InStr=InStr+"^"+$('#EdDate').val()
	InStr=InStr+"^"+$('#EdTime').val()
	InStr=InStr+"^"+$('#ActFlag').val()
	InStr=InStr+"^"+$('#UserDr').val()
	InStr=InStr+"^"+$('#Date').val()
	InStr=InStr+"^"+$('#Time').val()
	InStr=InStr+"^"+$('#Remark').val()
	InStr=InStr+"^"+$('#ExtStr01').val()
	InStr=InStr+"^"+$('#ExtStr02').val()
	InStr=InStr+"^"+$('#ExtStr03').val()
	InStr=InStr+"^"+$('#ExtStr04').val()
	InStr=InStr+"^"+$('#ExtStr05').val()
	
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
	var InStr=$('#RRowid').val()
	InStr=InStr+"^"+$('#RCTDr').val()
	InStr=InStr+"^"+$('#RCenterNo').val()
	InStr=InStr+"^"+$('#RStates').val()
	InStr=InStr+"^"+$('#RSeriNo').val()
	InStr=InStr+"^"+$('#RBusiNo').val()
	InStr=InStr+"^"+$('#RInsuType').val()
	InStr=InStr+"^"+$('#RHSPUserDr').val()
	InStr=InStr+"^"+$('#RHSPFlag').val()
	InStr=InStr+"^"+$('#RHSPDate').val()
	InStr=InStr+"^"+$('#RHSPTime').val()
	InStr=InStr+"^"+$('#RISPUserDr').val()
	InStr=InStr+"^"+$('#RISPFlag').val()
	InStr=InStr+"^"+$('#RISPDate').val()
	InStr=InStr+"^"+$('#RISPTime').val()
	InStr=InStr+"^"+$('#RUserDr').val()
	InStr=InStr+"^"+$('#RDate').val()
	InStr=InStr+"^"+$('#RTime').val()
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
			height:255,
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



function ReBuildInLocRec()
{

	var InsuTypeDesc=$("#RdInsuTypeDesc").val();
	var InsuType=$("#RdInsuType").val();
	var ExpStr=$("#RdCenter").val()+"^"+$("#RdStates").val()+"^^^^^"
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
	         $.messager.alert("生成记录提示", rtn, 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         //QryInLoc();
		});	
		 //setTimeout('$.messager.progress("close");', 2 * 1000);
	 } 
		
});
	
}

//重新生成科室信息 
function ReBuildInLoc()
{
	
$.messager.confirm("生成", "确定重新生成科室信息?", function (r) {
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
			  ExpStr:"^^^^^"
			  
			  },
			  function(rtn){
			
	         $.messager.alert("提示", rtn, 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         QryInLoc();
		});	
		
		
	 } 
		
});

			
	
}


//科室上传
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("提示", "请选择医保类型", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid

	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	}

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
	QryInLoc();
	QryInLocRec();
}