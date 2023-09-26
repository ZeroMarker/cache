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
	//ICD����datagrid
	var icdgrp = $HUI.datagrid("#icdconfig-icdgrp",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.ICDConfig",
			////////////////////////////////////////////
			//1��ͨ��query�õ�����
			//QueryName:"MRICDCateData",	
			//////////////////////////////////////////////////////
			//MethodName:"getMRICDCateData",	//ͨ�������õ�grid���ݣ������ڷ���ֵ��
			//////////////////////////////////////////////////////
			MethodName:"GetMRICDCateData2",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
			wantreturnval:0,
			///////////////////////////////////////////////
			filterRule:""
		},
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select�¼���Ӧ����
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				var p = icdgrp.getPanel();
				//enable ICD�����ɾ����ť
				p.find("#delgrp").linkbutton("enable");
				
				var p = icddetail.getPanel();
				//enable ICD��ϸ��ɾ����ť
				p.find("#delalldetail").linkbutton("enable");
				//enable ICD��ϸ��������ť
				p.find("#adddetail").linkbutton("enable");
				
				var row = icdgrp.getSelected();
				if (row){
					//���� ICD��ϸdatagrid
					icddetail.load({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"GetMRICDCateDetails",ICDCId:row.ICDCId,wantreturnval:0});
				}
				
				
				
				
				
			}
		},
		onLoadSuccess:function(data) {
				$("#delgrp").linkbutton("disable");
				
				$("#delalldetail").linkbutton("disable");
				//enable ICD��ϸ��������ť
				$("#adddetail").linkbutton("disable");
				$("#deldetail").linkbutton("disable");
				$("#modifydetail").linkbutton("disable");
				$('#icdconfig-icddetail').datagrid('loadData',{rows:[],total:0})							
		}
	});
	//��̬���Ӳ�ѯ����ע��
  	//$col =$('<td  style="text-align:right"><span style="padding-left:10px;"></span><input id="searchText" class="hisui-searchbox" style="width:180px;"><span style="padding-left:10px;"></span></td>')
  	//$(".datagrid-toolbar>table>tbody>tr").append($col);	
	
	//ICD����-���� ��Ӧ����
	$("#addgrp").click(function (argument) {
		saveGrpHandler("","","","");
	});
	//ICD����-ɾ�� ��Ӧ����
	$("#delgrp").click(function (argument) {
		var detailRows=$("#icdconfig-icddetail").datagrid("getRows");
		if(detailRows.length>0){
			$.messager.alert("��ʾ","�÷�������ICD��ϸ������ɾ����ϸ");
			return;
		}
		var row = icdgrp.getSelected();
		if (row){
			$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
				if(r){
					//���ú�̨����ɾ������
					$.cm({ClassName:'web.DHCMRTJService',MethodName:'DelICDCateData','ICDCRowid':row.ICDCId},
					false,
					function(data){
						if("ok"==data.responseText){
							icdgrp.load();
							icddetail.load();
						}else{
							$.messager.alert("��ʾ",data.responseText);
						}
					});
				}
			});
		}
	});
		
	//ICD����-��ѯ ��Ӧ����	
	$('#searchText').searchbox({
    	searcher:function(value){
			icdgrp.load({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"GetMRICDCateData2",filterRule:value,"wantreturnval":0}); 
    	}
	});

	//ICD����-���� ��Ӧ����
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
				text:'����',
				handler:function(){
					/*if ($("#grpDlgICDCCode").val()=="") {
						$.messager.alert("��ʾ","���벻��Ϊ�գ�");
						return;
					}*/
					if (!$("#grpDlgICDCCode").validatebox("isValid")){
						myMsg("����ֻ�������ֺ���ĸ�����");
						return;
					}
					if ($("#grpDlgICDCDesc").val()=="") {
						$.messager.alert("��ʾ","���Ʋ���Ϊ�գ�");
						return;
					}
					var data = $.cm({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"addMRICDCate",
							"ICDInfo":$("#grpDlgICDCCode").val()+"^"+$("#grpDlgICDCDesc").val()+"^"+$("#grpDlgICDCCate").combobox('getText')+"^"+$("#grpDlgICDCRemark").val()
						},false,function(data){
							if("ok"==data.responseText){
								grpAddDlgObj.close();
								icdgrp.load();
							}else{
								$.messager.alert("��ʾ",data.responseText);
							}
						});
				}
			},{
				text:'�ر�',
				handler:function(){
					grpAddDlgObj.close();
				}
			}]
		});	
	}
	
	
	//ICD��ϸdatagrid
	var icddetail = $HUI.datagrid("#icdconfig-icddetail",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.MRBase.ICDConfig",
			MethodName:"GetMRICDCateDetails",		//ͨ�������õ�grid���ݣ���������ֵ������ֱ���ڷ��������	
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
			text:'����',
			disabled:true,
			id:'adddetail',
			handler:function(){
				saveDetailHandler("","","","icon-w-add","����");
			}
		},{
			iconCls:'icon-write-order',
			text:'�޸�',
			disabled:true,
			id:'modifydetail',
			handler:function(){
				var row = icddetail.getSelected();
				saveDetailHandler(row.ICDCDDesc,row.ICDCDICD,row.ICDCDId,"icon-w-edit","�޸�");
			}
		},{
			iconCls:'icon-cancel',
			text:'ɾ��',
			disabled:true,
			id:'deldetail',
			handler:function(){
				var rowGrp =icdgrp.getSelected();
				var row = icddetail.getSelected();
				if (row){
					$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
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
									$.messager.alert("��ʾ",data.responseText);
								}
							});
						}
					});
				}				
			}
		},{
			iconCls:'icon-remove',
			text:'ȫ��ɾ��',
			disabled:true,
			id:'delalldetail',
			handler:function(){
				var rowGrp =icdgrp.getSelected();
				if (rowGrp){
					$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
						if(r){
							$.cm({ClassName:'web.DHCMRTJService',MethodName:'DelMRICDCDetails','ICDCRowid':rowGrp.ICDCId,'ICDCDId':'A'},
							false,
							function(data){
								if("ok"==data.responseText){
									icddetail.load();
								}else{
									$.messager.alert("��ʾ",data.responseText);
								}
							});
						}
					});
				}	
			}
			
		},{
			iconCls:'icon-save',
			text:'����˳��',
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
					$.messager.alert("��ʾ","û�пɹ����������!");
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
							$.messager.alert("��ʾ",data.responseText);
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
				//enable ICD��ϸ��������ť
				//$("#adddetail").linkbutton("disable");
				$(this).datagrid('enableDnd');
				$("#deldetail").linkbutton("disable");
				$("#modifydetail").linkbutton("disable");							
		}
	});
	//ICD��ϸ-���� ��Ӧ����
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
				text:'����',
				handler:function(){
					
					if ($("#detailDlgICDCDDesc").val()=="") {
						$.messager.alert("��ʾ","��������Ϊ�գ�");
						return;
					}
					if ($("#detailDlgICDCDICD").val()=="") {
						$.messager.alert("��ʾ","ICDֵ����Ϊ�գ�");
						return;
					}					
					
					
					
					
					
					var row = icdgrp.getSelected();
					var data = $.cm({ClassName:"web.DHCWL.V1.MRBase.ICDConfig",MethodName:"editMRICDCateDetails2","editStr":row.ICDCId+"^"+ICDCDId+"^"+$("#detailDlgICDCDDesc").val()+"^"+$("#detailDlgICDCDICD").val()
						},false,function(data){
							if("ok"==data.responseText){
								detailAddDlgObj.close();
								icddetail.load();
							}else{
								$.messager.alert("��ʾ",data.responseText);
							}
						});
					
				}
			},{
				text:'�ر�',
				handler:function(){
					detailAddDlgObj.close();
				}
			}]
		});	
	}
};
$(init);