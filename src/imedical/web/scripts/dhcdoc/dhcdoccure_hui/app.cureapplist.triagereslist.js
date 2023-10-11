var appList_triageResListObj=(function(){
	var CureRBCResListDataGrid;
	function InitTriageResListEvent(){
		$('#btnTriageResListSearch').click(function(){
			CureRBCResListDataGridLoad();
		});
	    
	    $('#btnTriage').click(function(){
			TriageOnClick();
		})
	}

	function InitCureRBCResListDataGrid()
	{
		CureRBCResListDataGrid=$('#tabCureRBCResList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			checkOnSelect:true,
			fitColumns : true,
			autoRowHeight : false,
			nowrap: false,
			collapsible:false,
			url : '',
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"DDCTRROWID",
			pageSize : 10,
			pageList : [5,10,50],
			columns :[[ 
				//{field:'RowCheck',checkbox:true},     
				{field:'DDCTRROWID',title:'',width:35,align:'left',hidden:true},   
				{field:'DDCTRCTLoc',title:'科室',width:100,align:'left'},   
				{field:'DDCTRResDesc',title:'资源名称',width:100,align:'left'},   
				{field:'CureTriageNum',title:'已分配人数',width:50,align:'left'},
				{field:'DDCTRLeftCount',title:'剩余可分配人数',width:50,align:'left'},
				{field:'DDCTRCount',title:'最大可分配人数',width:50,align:'left'},
				{field:'DDCTRHistoryRes',title:'是否历史分配',width:50,align:'left'
					,formatter:function(value,row,index){
						if (value==$g("是")){
							return "<span class='fillspan-no'>"+value+"</span>";
						}
					}
				}
			]] 
		});
		CureRBCResListDataGridLoad();
	}
	function CureRBCResListDataGridLoad()
	{
		var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
		var queryLoc=$("#ComboLoc").combogrid("getValue");
		var SessionStr=com_Util.GetSessionStr();
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.Triage",
			QueryName:"QueryTriageResource",
			'DCARowIDStr':DCARowIdStr,
			'LocRowID':queryLoc,
			'LogLocID':PageAppListAllObj._SELECT_DCARecLOCROWID, //session['LOGON.CTLOCID']
			SessionStr:SessionStr,
			Pagerows:CureRBCResListDataGrid.datagrid("options").pageSize,
			rows:99999
		},function(GridData){
			CureRBCResListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('unselectAll').datagrid('loadData',GridData); 
		})
	}

	function CureTriageNumClick(index){
		var selected=CureRBCResListDataGrid.datagrid('getRows'); 
		var DDCTRROWID=selected[index].DDCTRROWID;
		var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
		//var OperateType=$('#OperateType').val();
		var href="dhcdoc.cure.curetriagelist.csp?DCARowId="+DCARowIdStr+"&DDCTRIRowID="+DDCTRROWID;
		if(typeof websys_writeMWToken=='function') href=websys_writeMWToken(href);
		var ReturnValue=window.open(href,"","dialogwidth:60em;dialogheight:30em;status:no;center:1;resizable:yes");
		
	}

	function InitTriageLoc()
	{
	    $.cm({
			ClassName:"DHCDoc.DHCDocCure.Config",
			QueryName:"QueryCureLoc",		
			HospID:	session['LOGON.HOSPID'],	
			dataType:"json",
			rows:99999
		},function(Data){
			var cbox = $HUI.combobox("#ComboLoc", {
				valueField: 'LocId',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onSelect:function(){
			    	CureRBCResListDataGridLoad();
			    },onChange:function(n,o){
				    if(n==""){
			    		CureRBCResListDataGridLoad();
				    }
			    }
			 });
		});
	};

	function TriageOnClick(){
		var DCARowIdStr=PageAppListAllObj._SELECT_DCAROWID; //$('#DCARowIdStr').val();
		if(DCARowIdStr==""){
			$.messager.alert("提示", "请选择待分配的申请单", 'warning')
			return false;	
		}
		var selected=CureRBCResListDataGrid.datagrid('getRows'); 
		var rows = CureRBCResListDataGrid.datagrid("getSelections");
		if (rows.length == 0) {
			$.messager.alert("提示", "请选择分配的资源", 'warning')
			return false;
		}
	    if (rows.length > 0) {
			var ids = [];
			for (var i = 0; i < rows.length; i++) {
				ids.push(rows[i].DDCTRROWID);
			}
			var ID=ids.join(',');
			var DCARowIdArr=DCARowIdStr.split("!");
			var err="";
			var success=1;
			for(var j=0;j<DCARowIdArr.length;j++){	
				var oneDCARowId=DCARowIdArr[j];		
				var CureAppInfo=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",oneDCARowId);
				var PatName="";
				var ArcimDesc="";
				if(CurePatInfo!=""){
					var CurePatInfo=CureAppInfo.split(String.fromCharCode(1))[0];
					var CureInfo=CureAppInfo.split(String.fromCharCode(1))[1];
					var PatName=CurePatInfo.split("^")[2];
					var ArcimDesc=CureInfo.split("^")[0];
				}
				
				//多人分配，需要进行同步处理
				var Para=oneDCARowId+"^"+session['LOGON.USERID'];
				var value=$.cm({
					ClassName:"DHCDoc.DHCDocCure.Triage",
					MethodName:"CureTriaged",
					DDCTRResID:ID,
					Para:Para,
					dataType:'text'
				},false);
				if(value=="0"){
					var obj=window.frames.parent
				}else{
					success=0;
					var err=value
					if (value==100) err="有参数为空";
					else if(value==101) err="分配资源ID为空";
					else if(value==102) err="该申请单已分配";
					else if(value==103) err="该分配资源人员已满.";
					else if(value==104) err="该申请单已撤销.";
					else if(value=="-301") err="保存分配记录失败";
					else if(value=="-300") err="更新申请单状态失败";
					$.messager.alert('警告',$g("分配失败:")+$g(err),"warning");	
				}
			}
			if(err==""){$.messager.popover({msg: '分配成功！',type:'success',timeout: 3000})}
			CureRBCResListDataGridLoad();
			if(ServerObj.LayoutConfig=="1"){
				if(window.frames.parent.CureApplyDataGrid){
					window.frames.parent.RefreshDataGrid();
				}else{
					RefreshDataGrid();	
				}
			}
	    }
	}
	
	return{
		"InitTriageLoc":InitTriageLoc,
		"InitCureRBCResListDataGrid":InitCureRBCResListDataGrid,
		"InitTriageResListEvent":InitTriageResListEvent,
		"CureRBCResListDataGridLoad":CureRBCResListDataGridLoad
	}
})()