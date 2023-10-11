var workList_RecordListObj=(function(){
	var CureRecordDataGrid;
	function InitCureRecordDataGrid(){
		var cureRecordToolBar = [{
			id:'BtnDetailView',
			text:'���', 
			iconCls:'icon-funnel-eye',  
			handler:function(){
				DetailView();
			}
		},{
			id:'BtnCancelRecord',
			text:'�������Ƽ�¼', 
			iconCls:'icon-cancel',  
			handler:function(){
				CancelRecord_Click();
			}
		},{
			id:'BtnUploadPic',
			text:'�ϴ�ͼƬ', 
			iconCls:'icon-upload-cloud',  
			handler:function(){
				UploadPic_Click();
			}
		}];
		CureRecordDataGrid=$('#tabCureRecordList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : true,
			autoRowHeight : false,
			//scrollbarSize : '40px',
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"Rowid",
			pageSize : 5,
			pageList : [5,15,50,100],
			columns :[[   
	        			{field:'Rowid',title:'',width:1,hidden:true}, 
	        			{field:'PatientNo',title:'�ǼǺ�',width:100,align:'left'},   
	        			{field:'PatientName',title:'����',width:80,align:'left'},
	        			{field:'DCRTitle',title:'����',width:300},  
	        			{field:'CreateUser',title:'������',width:100},
	        			{field:'CreateDate',title:'����ʱ��',width:100},
	        			{field:'IsPicture',title:'�Ƿ���ͼƬ',width:70,
		        			formatter:function(value,row,index){
								return '<a href="###" id= "'+row["Rowid"]+'"'+' onmouseover=workList_RecordListObj.ShowCurePopover(this);'+' onclick=workList_RecordListObj.ShowCureRecordPic(\''+row.Rowid+'\');>'+row.IsPicture+"</a>"
							},
							styler:function(value,row){
								return "color:blue;text-decoration: underline;"
						}},
						{ field: 'Trance', title: '����׷��', width:60, sortable: false, align: 'center', formatter: function (value, rowData, rowIndex) {
						      retStr = "<a href='#' title='���ƹ���׷��'  onclick='workList_RecordListObj.ShowReportTrace(\""+rowData.Rowid+"\")'><span class='icon-track' title='���ƹ���׷��')>&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>"
							  return retStr;
						  }
						},
	        			{field:'UpdateUser',title:'��������',width:100},
	        			{field:'UpdateDate',title:'������ʱ��',width:100} ,
	        			{field:'ID',title:'ID',width:50}    
	    			 ]] ,
	    	toolbar : cureRecordToolBar,
	    	onDblClickRow:function(rowIndex, rowData){ 
				DetailView();
	       }
		});
	}
	/**
	*���Ƽ�¼�б����ݼ���
	**/
	function CureRecordDataGridLoad()
	{
		var DCARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID;
		var DCARowId="";
		if(DCARowIdStr!="")DCARowId=DCARowIdStr;
		var DCAOEOREDR=""; 
		if(CureRecordDataGrid){
			CureRecordDataGrid.datagrid({
				url:$URL,
				queryParams:{
					ClassName:"DHCDoc.DHCDocCure.Record",
					QueryName:"FindCureRecordList",
					'DCARowIdStr':DCARowId,
					'DCAOEOREDR':DCAOEOREDR,
					'Type':"APP",
				}	
			})
		}
	}
	/**
	*���Ƽ�¼���
	**/
	function ShowCureRecordDiag(DCRRowId,callback)
	{
		var OperateType=$('#OperateType').val();
		var DCAARowId="";
		
		var href="doccure.curerecord.hui.csp";
		var wd="1000px";
		var ht="550px";
		var DHCDocCureRecordLinkPage=ServerObj.DHCDocCureRecordLinkPage;
		if(DHCDocCureRecordLinkPage.indexOf(".csp")>-1){
			var arr=DHCDocCureRecordLinkPage.split("&");
			href=arr[0];
			if(arr.length>1){
				wd=arr[1].split("=")[1];
			}
			if(arr.length>2){
				ht=parseInt(arr[2].split("=")[1])+50;
			}
		}
		
		var href=href+"?OperateType="+OperateType+"&DCAARowId="+DCAARowId+"&DCRRowId="+DCRRowId;
	    websys_showModal({
			url:href,
			title:$g('���Ƽ�¼���'),
			width:wd,height:ht,
			onClose: function() {
				if(typeof(callback)=='function'){
					callback();
				}else{
					CureRecordDataGridLoad();
				}
			}
		});
	}
	/**
	*���Ƽ�¼���
	**/
	function DetailView(){
		var DCRRowId=GetSelectRow()
		if(DCRRowId==""){
			return false;
		}
		ShowCureRecordDiag(DCRRowId);	
	}
	function CancelRecord_Click(){
		var DCRRowId=GetSelectRow()
		if(DCRRowId==""){
			return false;
		}
		CancelRecord(DCRRowId);	
	}
	/**
	*���Ƽ�¼��������
	**/
	function CancelRecordBatch(DCRRowIdStr,callback){
		if(DCRRowIdStr==""){
			return false;
		}
		$.messager.confirm('ȷ��','�Ƿ�ȷ�ϳ���ѡ�е����Ƽ�¼?',function(r){    
			if (r){ 
				var UpdateObj={}
				new Promise(function(resolve,rejected){
					//����ǩ��
					CASignObj.CASignLogin(resolve,"CancelCureRecord",false)
				}).then(function(CAObj){
					return new Promise(function(resolve,rejected){
				    	if (CAObj == false) {
				    		return websys_cancel();
				    	} else{
					    	$.extend(UpdateObj, CAObj);
					    	resolve(true);
				    	}
					})
				}).then(function(){   
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.Record",
						MethodName:"CancelRecordBatch",
						DCRRowIdStr:DCRRowIdStr,
						UserID:session['LOGON.USERID'],
						dataType:"text"
					},function testget(value){
						var ErrMsg=value.split(String.fromCharCode(1))[0];
						var SuccessId=value.split(String.fromCharCode(1))[1];
						if(ErrMsg=="0"){
							$.messager.popover({msg: '�����ɹ�!',type:'success',timeout: 2000});
							if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, SuccessId, "CancelCureRecord");
							if(typeof(callback)=='function'){
								callback();
							}else{
								CureRecordDataGridLoad();
								if(window.frames.parent.CureApplyDataGrid){
									window.frames.parent.RefreshDataGrid();
								}else{
									RefreshDataGrid();	
								}
							}
						}else{
							$.messager.alert('��ʾ',ErrMsg);
							return false;	
						}
					})
				})
			}
		})
	}
	
	/**
	*���Ƽ�¼����
	**/
	function CancelRecord(DCRRowId,callback){
		if(DCRRowId==""){
			return false;
		}
		$.messager.confirm('ȷ��','�Ƿ�ȷ�ϳ������Ƽ�¼?',function(r){    
			if (r){ 
				var UpdateObj={}
				new Promise(function(resolve,rejected){
					//����ǩ��
					CASignObj.CASignLogin(resolve,"CancelCureRecord",false)
				}).then(function(CAObj){
					return new Promise(function(resolve,rejected){
				    	if (CAObj == false) {
				    		return websys_cancel();
				    	} else{
					    	$.extend(UpdateObj, CAObj);
					    	resolve(true);
				    	}
					})
				}).then(function(){   
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.Record",
						MethodName:"CancelRecord",
						'DCRRowId':DCRRowId,
						'UserID':session['LOGON.USERID'],
						dataType:"text"
					},function testget(value){	
						if(value=="0"){
							$.messager.popover({msg: '�����ɹ�!',type:'success',timeout: 1000});
							if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, DCRRowId, "CancelCureRecord");
							if(typeof(callback)=='function'){
								callback();
							}else{
								CureRecordDataGridLoad();
								if(window.frames.parent.CureApplyDataGrid){
									window.frames.parent.RefreshDataGrid();
								}else{
									RefreshDataGrid();	
								}
							}
						}else{
							var msg=value.split("^")[1];
							$.messager.alert('��ʾ',msg);
							return false;	
						}
					})
				})
			}
		})
	}
	function UploadPic_Click(){
		var DCRRowId=GetSelectRow()
		if(DCRRowId==""){
			return false;
		}
		UploadPic(DCRRowId,CureRecordDataGridLoad)
	}
	/**
	*����ͼƬ�ϴ�
	**/
	function UploadPic(DCRRowId,callback){
		var posn="height="+500+",width="+400+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
		var href="doccure.curerecord.picupload.hui.csp?DCRRowId="+DCRRowId;
		websys_showModal({
			url:href,
			title:$g('���Ƽ�¼ͼƬ�ϴ�'),
			iconCls:"icon-w-upload",
			width:"500px",height:"240px",
			CureRecordDataGridLoad:callback
		});
	}
	function GetSelectRow(){
		var rows = CureRecordDataGrid.datagrid("getSelections");
		if (rows.length==0) 
		{
			$.messager.alert("��ʾ","��ѡ��һ�����Ƽ�¼");
			return "";
		}else if (rows.length>1){
	 		$.messager.alert("����","��ѡ���˶�����Ƽ�¼��",'err')
	 		return "";
		}
		var DCRRowId=""
		var rowIndex = CureRecordDataGrid.datagrid("getRowIndex", rows[0]);
		var selected=CureRecordDataGrid.datagrid('getRows'); 
		var DCRRowId=selected[rowIndex].Rowid;
		if(DCRRowId=="")
		{
			$.messager.alert('��ʾ','��ѡ��һ�����Ƽ�¼');
			return "";
		}
		return DCRRowId;
	}
	
	function ShowCurePopover(that){
		var title=""
		var content=$g("�������ͼƬ")
		$(that).webuiPopover({
			title:title,
			content:content,
			trigger:'hover',
			placement:'top',
			style:'inverse'
		});
		$(that).webuiPopover('show');
	}
	/**
	*����ͼƬ���
	**/
	function ShowCureRecordPic(DCRRowId,callBack){
		if(typeof callBack=='undefined'){
			callBack=CureRecordDataGridLoad;
		}
		var posn="height="+600+",width="+800+",top=0,left=0,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes";
		var href="doccure.curerecord.picshow.hui.csp?DCRRowId="+DCRRowId+"&paramType=Original";
		websys_showModal({
			url:href,
			title:$g("���Ƽ�¼ͼƬ���"),
			iconCls:"icon-w-eye",
			width:"1000px",height:"700px",
			CureRecordDataGridLoad:callBack
		});	
	}
	
	/**
	*���ƹ���׷��
	**/
	function ShowReportTrace(DCARRowID,DCAARowID) {
		if(typeof DCAARowID=="undefined"){
			DCAARowID="";	
		}
		var width = document.body.clientWidth - 200;
		var height = 380;
		var src='doccure.curerecord.trace.hui.csp?DCARRowID='+DCARRowID+'&DCAARowID='+DCAARowID;
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		$("#win_ReportTrace").window({
			modal:true,
			title:$g("���ƹ���׷��"),
			collapsible:false,
			iconCls:'icon-message',
			width:width,
			height:height,
			content:'<iframe src="'+src+'" scrolling="no" frameborder="0" style="width:100%;height:90%;"></iframe>'
		});
	}
	
	return {
		"InitCureRecordDataGrid":InitCureRecordDataGrid,
		"CureRecordDataGridLoad":CureRecordDataGridLoad,
		"ShowCurePopover":ShowCurePopover,
		"ShowCureRecordPic":ShowCureRecordPic,
		"ShowReportTrace":ShowReportTrace,
		"UploadPic":UploadPic,
		"CancelRecord":CancelRecord,
		"CancelRecordBatch":CancelRecordBatch,
		"ShowCureRecordDiag":ShowCureRecordDiag
	}
})()