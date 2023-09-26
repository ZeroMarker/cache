
var init=function() {
	
	///////////////////////////////////////////////////////////////////////////////
	///组
	var grpGrid = $HUI.datagrid("#grpGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"GetGrp",
			searchV:"",
			wantreturnval:0
		},		
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'}
	    ]],
	    
		pagination:true,
		pageSize:50,
	    pageList:[5,10,15,20,50,100],
		fitColumns:true,
		onClickRow:function(rowIndex, rowData){
			//1、新增按钮置enable
			$("#MemberAddBtn").linkbutton("enable");
			//2、查询报表分给了哪些组
			$("#MemberSearchBtn").searchbox("setValue","");
			$("#memberGrid").datagrid("load",{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetMapedMember",
				searchV:"",
				grpID:rowData.ID,
				wantreturnval:0
			})
			
			
		}
	});	
	
	
	///////////////////////////////////////////////////////////////////////////////
	///组内人员
	var memberGrid = $HUI.datagrid("#memberGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"GetMapedMember",
			grpID:"", 
			searchV:"",
			wantreturnval:0
		},	
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'SSUSR_Name',title:'姓名',width:100,align:'left'},
			{field:'CTLOC_Desc',title:'默认登录科室',width:100,align:'left'},
			{field:'CTCPT_Desc',title:'医护人员类型',width:100,align:'left'},
			{field:'SSGRP_Desc',title:'HIS安全组',width:100,align:'left'},			
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
					var selector='"#memberGrid"';
					var s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRec("+selector+","+rowdataid+",init.removeMemberCB)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					return s;
				} 
			}
	    ]],

		pagination:true,
		pageSize:50,
	    pageList:[5,10,15,20,50,100],
		fitColumns:true
	});
	
	//查询报表
		///组界面查询响应方法
	$('#GrpSearchBtn').searchbox({
		searcher:function(value){
			$('#grpGrid').datagrid('load',{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetGrp",
				searchV:value,
				wantreturnval:0
						});

		}
	})
		///组用户界面查询响应方法
	$('#MemberSearchBtn').searchbox({
		searcher:function(value){
			var rowData=$("#grpGrid").datagrid("getSelected");
			if(rowData==null) {
				return;
			};
			
			$("#memberGrid").datagrid("load",{
				ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
				MethodName:"GetMapedMember",
				searchV:value,
				grpID:rowData.ID,
				wantreturnval:0
			})			
		}
	})
	

	
}

///“增加”的响应方法
var addMemberMapCfg=function(){
	//////////////////////////////////////////////////////////////////////////
	/////////增加报表映射
	var aryCheckedMember=[];

	////增加报表映射对话框
	var addMemberDlg = $HUI.dialog("#addMemberDlg",{
		
		iconCls:'icon-w-add',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false,
		buttons:[{
			text:'确定',
			handler:function(){
				if (aryCheckedMember.length==0) {
					$.messager.alert("提示","未选择医护人员！请勾选医护人员。");
					return;	
					
				}
				//报表ID
				var rowData=$("#grpGrid").datagrid("getSelected");
				$cm({
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"insertGMMap",
					wantreturnval:0,
					grpID:rowData.ID,
					userIDs:aryCheckedMember.join(",")
				},function(jsonData){
						if (jsonData.success==1) {
							//$.messager.alert("提示","添加成功！");
							aryCheckedMember=[];
							$("#memberGrid").datagrid("reload");
							var length=$("#memberGrid").datagrid("getRows").length;
							$("#memberGrid").datagrid("scrollTo",length-1);
							$('#addMemberDlg').dialog('close');
							$('#addMemberGrid').datagrid('loadData',{total:0,rows:[]});
								
						}else{
							$.messager.alert("提示",jsonData.msg);

						}
				});					
			}
		},{
			text:'取消',
			handler:function(){
				$('#addMemberDlg').dialog('close');	
				aryCheckedMember=[];
				$('#addMemberGrid').datagrid('loadData',{total:0,rows:[]});

			}
		}]
		
	});		
	
	var row=$("#grpGrid").datagrid("getSelected");
	
	///弹出的用户datagrid
	var addMemberGrid = $HUI.datagrid("#addMemberGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"getUnMapMember",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			grpID:row.ID,
			searchV:""
		},
		fit:true,
		fitColumns:true,
		rownumbers:true,    
		columns:[[
			{field:'ck',checkbox:'true'},
			{field:'SSUSR_RowId',title:'用户ID',width:100,align:'left',hidden:true},
			{field:'SSUSR_Name',title:'姓名',width:100,align:'left'},
			{field:'CTLOC_Desc',title:'默认登录科室',width:100,align:'left'},
			{field:'CTCPT_Desc',title:'医护人员类型',width:100,align:'left'},
			{field:'SSGRP_Desc',title:'HIS安全组',width:100,align:'left'}			
	    ]],
		pagination:true,
		pageSize:50,
	    pageList:[5,10,15,20,50,100],
	    onCheckAll:function(rows){
		    for(var i=0;i<rows.length;i++){
			    var rowData=rows[i];
			    if ($.inArray(rowData.SSUSR_RowId, aryCheckedMember)<0){
				    aryCheckedMember.push(rowData.SSUSR_RowId);
			    }
		    }
		    
	    },
	    onCheck:function(rowIndex,rowData){
		    if ($.inArray(rowData.SSUSR_RowId, aryCheckedMember)<0){
			    aryCheckedMember.push(rowData.SSUSR_RowId);
		    }
		    
	    },
	    onUncheck:function(rowIndex,rowData){
		    var inx=$.inArray(rowData.SSUSR_RowId, aryCheckedMember);
		    if (inx>=0)
		    {
			    aryCheckedMember.splice(inx,1);
		    }
	    },
	    onUncheckAll:function(rows) {
		    for(var i=0;i<rows.length;i++){
			    var rowData=rows[i];
			    var inx=$.inArray(rowData.SSUSR_RowId, aryCheckedMember);
			    if (inx>=0)
			    {
				    aryCheckedMember.splice(inx,1);
			    }
		    }
	    },
	    onLoadSuccess:function(data){
	    	for(var i=0;i<data.rows.length;i++){
		    	if ($.inArray(data.rows[i].SSUSR_RowId ,aryCheckedMember)>=0) {
			    	$("#addMemberGrid").datagrid("checkRow",i);
		    	}
		    }
	    }
		    
		    
		    
	});	
	
	
	
	
	
	$('#searchUnMapedMember').searchbox("setValue","");
	addMemberDlg.open();
	
	
	////////////////////////////////////////////////////////
	//
	$(function(){
		$('#searchUnMapedMember').searchbox({
			searcher:function(value){
				var row=$("#grpGrid").datagrid("getSelected");
				$("#addMemberGrid").datagrid("reload",({
					ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
					MethodName:"getUnMapMember",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
					wantreturnval:0,
					grpID:row.ID,
					searchV:value
				}))
			}
		});
	});}
$(init);

//移除grid中的一行记录
init.removeRec=function(gridSelector,ID,funCallback) {
		$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
		if (r) { 
				var colIndex=$(gridSelector).datagrid("getRowIndex",ID);
				$(gridSelector).datagrid("deleteRow",colIndex);
				if (funCallback!=null) {
					funCallback(ID);
				}
		}
		})
};

init.removeMemberCB=function(ID) {
	$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.PermisServ",
			MethodName:"DelMember",
			wantreturnval:0,
			mapID:ID
		},function(jsonData){
				if (jsonData.success==1) {
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});
}

