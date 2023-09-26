function dataLoaderOfGrp(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=getMRICDCate',
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
function dataLoaderOfDetail(params,successcb,errorcb){
    params.start=((params.page-1)*params.rows);
	params.limit=params.rows;
	$.ajax({
		url:'dhcwl/mrcfg/mrtjservice.csp?action=GetICDCateDetails&ICDCId='+params.ICDCId,
		type: "POST",
		dataType:"text",
		data:params,
		success: function(data){
			var json=eval('(' + data + ')');
			json.total=json.totalNum;
			json.rows=json.root;
			successcb(json)

		},error:function (XMLHttpRequest, textStatus, errorThrown) {
			alert("error");
		}
	});
}
var init = function(){
	//ICD分组datagrid
	var icdgrp = $HUI.datagrid("#icdconfig-icdgrp",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.ICDConfig",
			////////////////////////////////////////////
			//1、通过query得到数据
			//QueryName:"MRICDCateData",	
			//////////////////////////////////////////////////////
			//MethodName:"getMRICDCateData",	//通过方法得到grid数据，数据在返回值中
			//////////////////////////////////////////////////////
			MethodName:"GetMRICDCateData2",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			///////////////////////////////////////////////
			filterRule:""
		},
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select事件响应方法
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				var p = icdgrp.getPanel();
				//enable ICD分组的删除按钮
				p.find("#delgrp").linkbutton("enable");
				
				var p = icddetail.getPanel();
				//enable ICD明细的删除按钮
				p.find("#delalldetail").linkbutton("enable");
				//enable ICD明细的新增按钮
				p.find("#adddetail").linkbutton("enable");
				
				var row = icdgrp.getSelected();
				if (row){
					//加载 ICD明细datagrid
					icddetail.load({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"GetMRICDCateDetails",ICDCId:row.ICDCId,wantreturnval:0});
				}
				
				
				
				
				
			}
		},
		onLoadSuccess:function(data) {
				$("#delgrp").linkbutton("disable");
				
				$("#delalldetail").linkbutton("disable");
				//enable ICD明细的新增按钮
				$("#adddetail").linkbutton("disable");
				$("#deldetail").linkbutton("disable");
				$("#modifydetail").linkbutton("disable");
				$('#icdconfig-icddetail').datagrid('loadData',{rows:[],total:0})							
		}
	});
	//动态增加查询框，先注释
  	//$col =$('<td  style="text-align:right"><span style="padding-left:10px;"></span><input id="searchText" class="hisui-searchbox" style="width:180px;"><span style="padding-left:10px;"></span></td>')
  	//$(".datagrid-toolbar>table>tbody>tr").append($col);	
	
	//ICD分组-增加 响应方法
	$("#addgrp").click(function (argument) {
		saveGrpHandler("","","","");
	});
	//ICD分组-删除 响应方法
	$("#delgrp").click(function (argument) {
		var detailRows=$("#icdconfig-icddetail").datagrid("getRows");
		if(detailRows.length>0){
			$.messager.alert("提示","该分组下有ICD明细，请先删除明细");
			return;
		}
		var row = icdgrp.getSelected();
		if (row){
			$.messager.confirm("确认","确定删除?",function(r){
				if(r){
					//调用后台方法删除分组
					$.cm({ClassName:'web.DHCMRTJService',MethodName:'DelICDCateData','ICDCRowid':row.ICDCId},
					false,
					function(data){
						if("ok"==data.responseText){
							icdgrp.load();
							icddetail.load();
						}else{
							$.messager.alert("提示",data.responseText);
						}
					});
				}
			});
		}
	});
		
	//ICD分组-查询 响应方法	
	$('#searchText').searchbox({
    	searcher:function(value){
			icdgrp.load({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"GetMRICDCateData2",filterRule:value,"wantreturnval":0}); 
    	}
	});

	//ICD分组-增加 响应方法
	var saveGrpHandler = function(Code,Desc,Cate,Remark){
		$("#grpDlgICDCCode").val(Code);
		$("#grpDlgICDCDesc").val(Desc);
		$("#grpDlgICDCCate").val(Cate);
		$("#grpDlgICDCRemark").val(Remark);
		$("#icdconfig-icdgrp-AddDlg").show();
		var grpAddDlgObj = $HUI.dialog("#icdconfig-icdgrp-AddDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			onOpen:function(){
				var newWidth=$("#addicdgrpForm tr:eq(0) td:eq(2)").width()+12;
				$('#grpDlgICDCCate').combobox("resize",newWidth);
			},
			buttons:[{
				text:'保存',
				handler:function(){
					/*if ($("#grpDlgICDCCode").val()=="") {
						$.messager.alert("提示","编码不能为空！");
						return;
					}*/
					if (!$("#grpDlgICDCCode").validatebox("isValid")){
						myMsg("编码只能是数字和字母的组合");
						return;
					}
					if ($("#grpDlgICDCDesc").val()=="") {
						$.messager.alert("提示","名称不能为空！");
						return;
					}
					var data = $.cm({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"addMRICDCate",
							"ICDInfo":$("#grpDlgICDCCode").val()+"^"+$("#grpDlgICDCDesc").val()+"^"+$("#grpDlgICDCCate").combobox('getText')+"^"+$("#grpDlgICDCRemark").val()
						},false,function(data){
							if("ok"==data.responseText){
								grpAddDlgObj.close();
								icdgrp.load();
							}else{
								$.messager.alert("提示",data.responseText);
							}
						});
				}
			},{
				text:'关闭',
				handler:function(){
					grpAddDlgObj.close();
				}
			}]
		});	
	}
	
	
	//ICD明细datagrid
	var icddetail = $HUI.datagrid("#icdconfig-icddetail",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.ICDConfig",
			MethodName:"GetMRICDCateDetails",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0,
			ICDCId:""
		},
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,

		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			disabled:true,
			id:'adddetail',
			handler:function(){
				saveDetailHandler("","","","icon-w-add","新增");
			}
		},{
			iconCls:'icon-write-order',
			text:'修改',
			disabled:true,
			id:'modifydetail',
			handler:function(){
				var row = icddetail.getSelected();
				saveDetailHandler(row.ICDCDDesc,row.ICDCDICD,row.ICDCDId,"icon-w-edit","修改");
			}
		},{
			iconCls:'icon-cancel',
			text:'删除',
			disabled:true,
			id:'deldetail',
			handler:function(){
				var rowGrp =icdgrp.getSelected();
				var row = icddetail.getSelected();
				if (row){
					$.messager.confirm("确认","确定删除?",function(r){
						if(r){
							$.cm({ClassName:'web.DHCMRTJService',MethodName:'DelMRICDCDetails','ICDCRowid':rowGrp.ICDCId,'ICDCDId':row.ICDCDId},
							false,
							function(data){
								if("ok"==data.responseText){
									icddetail.load();
									
									var p = icddetail.getPanel();
									p.find("#deldetail").linkbutton("disable");
									p.find("#modifydetail").linkbutton("disable");
								}else{
									$.messager.alert("提示",data.responseText);
								}
							});
						}
					});
				}				
			}
		},{
			iconCls:'icon-remove',
			text:'全部删除',
			disabled:true,
			id:'delalldetail',
			handler:function(){
				var rowGrp =icdgrp.getSelected();
				if (rowGrp){
					$.messager.confirm("确认","确定删除?",function(r){
						if(r){
							$.cm({ClassName:'web.DHCMRTJService',MethodName:'DelMRICDCDetails','ICDCRowid':rowGrp.ICDCId,'ICDCDId':'A'},
							false,
							function(data){
								if("ok"==data.responseText){
									icddetail.load();
								}else{
									$.messager.alert("提示",data.responseText);
								}
							});
						}
					});
				}	
			}
			
		},{
			iconCls:'icon-save',
			text:'保存顺序',
			id:'saveorder',
			handler:function(){
				var pager=icddetail.getPager();
				var pageSize=pager.data("pagination").options.pageSize;				
				var pageNumber=pager.data("pagination").options.pageNumber;
				var rows=icddetail.getRows();
				var idStr="";
				for (var i=0;i<rows.length;i++) {
					var MKCDId=rows[i].ICDCDId;
					if (idStr == "") {
						idStr = MKCDId
					} else {
						idStr = idStr + "-" + MKCDId
					}
				}
				
				if (idStr == "") {
					$.messager.alert("提示","没有可供保存的内容!");
					return;
				}				

				var rowGrp =icdgrp.getSelected();
				if (rowGrp){
					$.cm({ClassName:'web.DHCMRTJService',MethodName:'MRICDCateDetailsSort','ICDCId':rowGrp.ICDCId,'IdStr':idStr,'pageSize':pageSize,'pageNumber':pageNumber},
					false,
					function(data){
						if("ok"==data.responseText){
							icddetail.reload();
						}else{
							$.messager.alert("提示",data.responseText);
						}
					});
				}				
			}
		}],
		onSelect:function(rowIndex,rowData){
			var p = icddetail.getPanel();			
			if (rowIndex>-1){
				p.find("#deldetail").linkbutton("enable");
				p.find("#modifydetail").linkbutton("enable");
			}
		},
		onLoadSuccess:function(data) {
				//$("#delalldetail").linkbutton("disable");
				//enable ICD明细的新增按钮
				//$("#adddetail").linkbutton("disable");
				$(this).datagrid('enableDnd');
				$("#deldetail").linkbutton("disable");
				$("#modifydetail").linkbutton("disable");							
		}
	});
	//ICD明细-增加 响应方法
	var saveDetailHandler = function(Desc,ICD,ICDCDId,iconCls,title){
		$("#detailDlgICDCDDesc").val(Desc);
		$("#detailDlgICDCDICD").val(ICD);
		$("#icdconfig-icddetail-AddDlg").show();
		var detailAddDlgObj = $HUI.dialog("#icdconfig-icddetail-AddDlg",{
			iconCls:iconCls,
			title:title,
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(){
					
					if ($("#detailDlgICDCDDesc").val()=="") {
						$.messager.alert("提示","描述不能为空！");
						return;
					}
					if ($("#detailDlgICDCDICD").val()=="") {
						$.messager.alert("提示","ICD值不能为空！");
						return;
					}					
					
					
					
					
					
					var row = icdgrp.getSelected();
					var data = $.cm({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"editMRICDCateDetails2","editStr":row.ICDCId+"^"+ICDCDId+"^"+$("#detailDlgICDCDDesc").val()+"^"+$("#detailDlgICDCDICD").val()
						},false,function(data){
							if("ok"==data.responseText){
								detailAddDlgObj.close();
								icddetail.load();
							}else{
								$.messager.alert("提示",data.responseText);
							}
						});
					
				}
			},{
				text:'关闭',
				handler:function(){
					detailAddDlgObj.close();
				}
			}]
		});	
	}
};
$(init);