var PageLogicObj={
	CspName:"doccure.config.partgrpset.hui.csp",
	CurePartGrpSetDataGrid:"",
	CurePartGrpLinkSetDataGrid:"",
	CurePartSetDataGrid:"",
	RefCureItemDataGrid:"",
	editRefItemRow:"",
	PartType:[{id:"BP",desc:$g("部位")},{id:"A",desc:$g("穴位")}],
	Authority:[{id:"U",desc:$g("个人")},{id:"D",desc:$g("科室")},{id:"H",desc:$g("全院")}]
}

$(document).ready(function(){ 
	InitHospUser();
	InitEvent();
});	
function InitHospUser(){
	var hospComp = GenUserHospComp();
	hospComp.jdata.options.onSelect = function(e,t){
		CurePartGrpSetDataGridLoad();
		CurePartSetDataGridLoad();
		CurePartGrpLinkSetDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		CurePartGrpSetDataGridLoad();
		CurePartSetDataGridLoad();
	}	
}

function InitEvent(){
	$('#btnSave').click(function(){
		if(!SaveFormData())return false;
	});	
}

function InitPartType(){
	var ComboObj={
		data:PageLogicObj.PartType,
		valueField:"id",
		textField:"desc"
	};
	$HUI.combobox("#DDCPGSType",ComboObj);
	$.extend(ComboObj,{
		onChange:function(){
			CurePartGrpSetDataGridLoad();
		}	
	});
	$HUI.combobox("#SType",ComboObj);
}
function InitAuthority(){
	var ComboObj={
		data:PageLogicObj.Authority,
		valueField:"id",
		textField:"desc"	
	};
	$HUI.combobox("#DDCPGSAuthority",ComboObj);
	$.extend(ComboObj,{
		onChange:function(){
			CurePartGrpSetDataGridLoad();
		}	
	});
	$HUI.combobox("#SAuthority",ComboObj);
}

function Init(){
	InitPartType();
	InitAuthority();
	PageLogicObj.CurePartGrpSetDataGrid=InitCurePartGrpSetDataGrid();
	PageLogicObj.CurePartGrpLinkSetDataGrid=InitCurePartGrpLinkSetDataGrid();
	PageLogicObj.CurePartSetDataGrid=InitCurePartSetDataGrid();
}

function InitCurePartGrpSetDataGrid()
{
	var CurePartSetColumns=[[  
		{ field: 'CPGSRowid', title: 'ID', width: 1,hidden:true
		}, 
		{ field: 'CPGSTypeId', title: 'CPGSTypeid', width: 1,hidden:true
		}, 
		{ field: 'CPGSType', title:'类型', width: 80, sortable: false  
		},
		{ field: 'CPGSCode', title:'代码', width: 100, hidden: true  
		},
		{ field: 'CPGSDesc', title: '描述', width: 150, sortable: false
		},
		{ field: 'CPGSAlias', title: '别名', width: 150, sortable: false
		},
		{ field: 'CPGSAuthority', title: '权限类型', width: 80, sortable: false
		},
		{ field: 'CPGSAuthorityId', title: '权限类型id', hidden: true
		},
		{ field: 'CPGSDefaultFlag', title: '默认', width: 60,
			formatter:function(value,row,index){
				if (value == $g("是")) {
					return "<span class='fillspan'>"+value+"</span>";
				}else {
					return value;
				}
			}
		},
		{ field: 'CPGSActiveFlag', title: '激活', width: 60
		},
		{ field: 'AllowUpdateFlag', title: '允许修改标记', width: 100,hidden:(ServerObj.SuperFlag=="Y")?false:true
		}
	]];
	var CurePartGrpSetDataGrid=$("#tabCurePartGrpSet").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : true,
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartGrpSet",
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"CPGSRowid",
		pageSize: 25,
		pageList : [25,50,100],
		columns :CurePartSetColumns,
		//toolbar:CurePartSetToolBar,
		onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var UserHospID=GetUserHospID();
			var Type=$("#SType").combobox("getValue");
			var SDesc=$("#SDesc").searchbox("getValue");
			var SAuthority=$("#SAuthority").combobox("getValue");
			var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID']+"^"+session['LOGON.LANGID'];
			var SessionStr=SessionStr+"^"+PageLogicObj.CspName;
			var NotCheckKeyFlag=(ServerObj.SuperFlag=="Y")?ServerObj.SuperFlag:"";
			$.extend(param,{Type:Type,SDesc:SDesc,SAuthority:SAuthority,SessionStr:SessionStr,HospID:UserHospID,NotCheckKeyFlag:NotCheckKeyFlag});
		},
		onClickRow:function(rowIndex, rowData){ 
			CurePartGrpLinkSetDataGridLoad();
			CurePartSetDataGridLoad(rowData.CPGSRowid,rowData.CPGSTypeId)
		},
		onDblClickRow:function(rowIndex, rowData){ 
			UpdateGridData();
       }
	});
	return CurePartGrpSetDataGrid;
}

function CurePartGrpSetDataGridLoad()
{
	PageLogicObj.CurePartGrpSetDataGrid.datagrid("reload");
}

function InitCurePartGrpLinkSetDataGrid()
{
	var SetColumns=[[  
		{ field: 'CPGLRowid', title: 'ID', width: 1,hidden:true
		}, 
		{ field: 'CPGLSPartId', title: 'CPGLSPartId', width: 1,hidden:true
		}, 
		{ field: 'CPGLSPartDesc', title: '描述', width: 445, sortable: false
		}
	]];
	var CurePartGrpLinkSetDataGrid=$("#tabCurePartGrpLinkSet").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url : "", //$URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartGrpLinkSet",
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"CPGSRowid",
		pageSize: 10,
		pageList : [10,25,50,100],
		columns :SetColumns,
		//toolbar:CurePartSetToolBar,
		onLoadSuccess:function(data){
		}
	});
	return CurePartGrpLinkSetDataGrid;
}

function CurePartGrpLinkSetDataGridLoad(CPGLRowid)
{
	var UserHospID=GetUserHospID();
	var CPGSRowid="";
	var row = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',{total: 0, rows: []});
		PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid("clearSelections");
		return;
	}else{
		var CPGSRowid=row.CPGSRowid;
	}
			
	if(typeof CPGLRowid=="undefined"){CPGLRowid="";}
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		QueryName:"QueryPartGrpLinkSet",
		CPGSRowid:CPGSRowid,
		HospID:UserHospID
	},function testget(GridData){
		PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid("clearSelections");
		if(CPGLRowid!=""){
			SelectRowByCPGLRowid(CPGLRowid)
		}
	})
}

function SelectRowByCPGLRowid(SelRowid){
	var ListData = PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid('getData');
	var opts = PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid('options');
	var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	for (i=0;i<ListData.originalRows.length;i++){
		var CPGLRowid=ListData.originalRows[i].CPGLRowid;
		if(CPGLRowid==SelRowid){
			var NextRowIndex=i;
			
			var NeedPageNum=Math.ceil((NextRowIndex+1)/parseInt(opts.pageSize));
			if (opts.pageNumber!=NeedPageNum){
				PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid('getPager').pagination('select',NeedPageNum);
			}
			NextRowIndex=(NextRowIndex)%parseInt(opts.pageSize);
			PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid('selectRow',NextRowIndex);
		}
	}
}

function CheckData(){
	var DDCPGSType=$("#DDCPGSType").combobox("getValue");
	if(DDCPGSType=="")
	{
		$.messager.alert("提示", "类型不能为空", 'warning', function(){
			$('#DDCPGSType').next('span').find('input').focus();
		})
        return false;
	}
	var DDCPGSAuthority=$("#DDCPGSAuthority").combobox("getValue");
	if(DDCPGSAuthority=="")
	{
		$.messager.alert("提示", "权限类型不能为空",'warning', function(){
			$('#DDCPGSAuthority').next('span').find('input').focus();
		})
        return false;
	}
	var DDCPGSDesc=$("#DDCPGSDesc").val();
	if(DDCPGSDesc=="")
	{
		$.messager.alert('提示','描述不能为空', 'warning', function(){
			$("#DDCPGSDesc").focus();
		});   
        return false;
	}
	return true;
}

function AddGridData(){
	$("#add-dialog").dialog({
		title:"新增",
		iconCls:"icon-w-new",	
	}).dialog("open");
	$HUI.combobox("#DDCPGSType").enable();
	$('#add-form').form("clear")	
}

///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;    
	var DDCPGSROWID=$("#DDCPGSROWID").val();
	var DDCPGSType=$("#DDCPGSType").combobox("getValue");
	var DDCPGSAuthority=$("#DDCPGSAuthority").combobox("getValue");
	var DDCPGSCode=""; //$("#DDCPGSCode").val();
	var DDCPGSDesc=$("#DDCPGSDesc").val();
	var DDCPGSAlias=$("#DDCPGSAlias").val();
	var DDCPGSDefaultFlag=$("#DDCPGSDefaultFlag").radio("getValue");
	DDCPGSDefaultFlag=(DDCPGSDefaultFlag==true?"Y":"N");
	var DDCPGSAvailFlag=$("#DDCPGSAvailFlag").radio("getValue");
	DDCPGSAvailFlag=(DDCPGSAvailFlag==true?"Y":"N");
	var InputPara=DDCPGSROWID+"^"+DDCPGSType+"^"+DDCPGSCode+"^"+DDCPGSDesc+"^"+DDCPGSDefaultFlag+"^"+DDCPGSAvailFlag+"^"+DDCPGSAlias+"^"+DDCPGSAuthority;
	//alert(InputPara)
	var UserHospID=GetUserHospID();
	var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'];
	$.m({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		MethodName:"SaveCurePartGrpSet",
		SetPara:InputPara,
		SessionStr:SessionStr,
		HospID:UserHospID
	},function testget(value){
		if(value=="0"){
			$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
			$("#add-dialog").dialog( "close" );
			CurePartGrpSetDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="101") err="该部位/穴位组描述已存在";
			else err=value;
			$.messager.alert('提示',$g(err),"warning");   
			return false;
		}
	});
}
///修改表格函数
function UpdateGridData(){
	var row = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行需要修改的部位/穴位组行记录！",'warning')
	}else{
		var AllowUpdateFlag=row.AllowUpdateFlag;
		if(AllowUpdateFlag!="Y"){
			$.messager.popover({msg: '非本院、本科或本人记录,无权限修改.',type:'alert',timeout: 1000});
			return false;
		}
		$('#add-dialog').window({
			title:"修改",
			iconCls:"icon-w-save",	
		}).window('open');
		$('#add-form').form("clear");
		var DefaultFlag=(row.CPGSDefaultFlag==$g("是")?true:false);
		var ActiveFlag=(row.CPGSActiveFlag==$g("是")?true:false);
		
		$("#DDCPGSDefaultFlag").radio("setValue",DefaultFlag);
		$("#DDCPGSAvailFlag").radio("setValue",ActiveFlag);
		$("#DDCPGSType").combobox("setValue",row.CPGSTypeId);
		$("#DDCPGSAuthority").combobox("setValue",row.CPGSAuthorityId);
		$HUI.combobox("#DDCPGSType").disable();
		
		$('#add-form').form("load",{
			DDCPGSROWID:row.CPGSRowid,
			DDCPGSCode:row.CPGSCode,
			DDCPGSDesc:row.CPGSDesc,
			DDCPGSAlias:row.CPGSAlias	 
		})
	}
}

function GetUserHospID(){
	var UserHospID=$HUI.combogrid('#_HospUserList').getValue();
	return UserHospID
}

function ReHospitalHandle(){
	var row=PageLogicObj.CurePartGrpSetDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行记录！","warning")
		return false;
	}
	var GenHospObj=GenHospWin("DHC_DocCure_PartGrpSet",row["CPGSRowid"])
}


function InitCurePartSetDataGrid()
{
	var CurePartSetColumns=[[  
		{ field: 'CPSRowid', title: 'ID', checkbox: true
		}, 
		{ field: 'CPSDesc', title: '描述', width: 120, sortable: false,
			formatter:function(value,row,index){
				var myvalue="'"+value+"'"
				if (row.CPSActiveFlag!=$g("是")){
					value="<span style='color:red'>"+value+"</span>";
				}else{
					value="<span style='color:black'>"+value+"</span>";
				}
				value='<a class="editcls-Desc" id= "' + row["CPSRowid"] + '"onmouseover="com_Util.ShowDescPopover(this,'+myvalue+')">'+value+'</a>';
				if (row.CPSHasConfigFlag == "1") {
					return '<a href="###" class="editcls1"></a>'+value;
				}else {
					return value;
				}
				
				
				return '<a class="editcls-Desc" id= "' + row["ID"] + '"onmouseover="ShowDescDetail(this,'+myvalue+')">'+value+'</a>';
			}
		},
		{ field: 'CPSDetail', title: '属性查看', width: 80,
			formatter:function(value,row,index){
				if(row.CPSTypeid=="A"){
					return '<a href="#this" class="editcls" onclick="ShowCPSDetail('+(row.CPSRowid)+')"></a>';
				}else{
					return "";
				}
			}
		},
		{ field: 'CPSTypeid', title: 'CPGSTypeid', width: 1,hidden:true
		}, 
		{ field: 'CPSType', title:'类型', width: 65, sortable: false  
		},
		{ field: 'CPSDefaultFlag', title: '默认', width: 50,
			formatter:function(value,row,index){
				if (value == $g("是")) {
					return "<span class='fillspan'>"+value+"</span>";
				}else {
					return value;
				}
			}
		},
		{ field: 'CPSActiveFlag', title: '激活',hidden:true
		},
		{ field: 'CPSHasConfigFlag', title: '已关联',hidden:true
		}
	]];
	var CurePartSetDataGrid=$("#tabCurePartSet").datagrid({
		view:scrollview,
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		fitColumns : false,
		rownumbers:true,
		checkOnSelect:true,
		selectOnCheck:true,
		singleSelect:false,
		autoRowHeight:true,
		pagination:false,
		pageSize:20,
		idField:"CPSRowid",
		columns :CurePartSetColumns,
		//toolbar:CurePartSetToolBar,
		onLoadSuccess:function(data){
			$('.editcls').linkbutton({text:'',plain:true,iconCls:'icon-search'});
			$('.editcls1').linkbutton({text:'',plain:true,iconCls:'icon-compare-yes'});
			$(this).datagrid("clearChecked").datagrid("clearSelections");
		},
		onBeforeSelect:function(index, row){
			if(row.CPSHasConfigFlag=="1"){
				$(this).datagrid('uncheckRow', index);
				return false;	
			}
		},
		onBeforeCheck:function(index,row){
			if(row.CPSHasConfigFlag=="1"){
				$(this).datagrid('unselectRow', index);
				return false	
			}
		}
	});
	return CurePartSetDataGrid;
}

function CurePartSetDataGridLoad(CPGSRowid,CPGSTypeId)
{
	var rowData = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected");
	if (typeof CPGSRowid=='undefined'){
		CPGSRowid="";
	}
	if(rowData && CPGSRowid==""){CPGSRowid=rowData.CPGSRowid}
	if (typeof CPGSTypeId=='undefined'){
		CPGSTypeId="";
	}
	if(rowData && CPGSTypeId==""){CPGSTypeId=rowData.CPGSTypeId}
	
	var UserHospID=GetUserHospID();
	var SDesc=$("#SPartDesc").searchbox("getValue");
	$cm({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		QueryName:"QueryPartSetConfig",
		HospID:UserHospID,
		Type:CPGSTypeId,
		SDesc:SDesc,
		CPGSRowID:CPGSRowid,
		SActiveFlag:"Y",
		ExpStr:"^^"+PageLogicObj.CspName,
		ResultSetType:"array",
		page:1, 
		rows:99999
	},function(GridData){
		PageLogicObj.CurePartSetDataGrid.datagrid('loadData', GridData);
	});
};

function ShowCPSDetail(CPSRowid){
	$('#AcupDetail-dialog').window('open');
	
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.BodySet",
		MethodName:"GetAcupDetail",
		PartId:CPSRowid
	},function(ret){
		if(typeof(ret)=="object"){
			$("#AcupPosition").val(ret.AcupPosition);
			$("#AcupAttending").val(ret.AcupAttending);
			$("#AcupOperation").val(ret.AcupOperation);
			$("#AcupImgDiagramShow").attr("src",ret.AcupImgDiagramShow);
			$("#AcupImgDiagramShow").unbind();
			if(ret.AcupImgDiagramShow!=""){
				$("#AcupImgDiagramShow").attr("title",$g("点击图片查看大图"));
				$("#AcupImgDiagramShow").bind("click",function(){
					showImage(this)	
				})
			}else{
				$("#AcupImgDiagramShow").attr("title","");	
			}
		}else{
			$.messager.popover({msg: '穴位属性数据获取异常',type:'alert',timeout: 1000});
		}
	})	
}

function SavePartGrpLinkSet(){
	var row = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请在左侧列表选择一行需要关联的部位/穴位组行记录！",'warning');
		return false;
	}else{
		var CPGSRowid=row.CPGSRowid;
		var rows = PageLogicObj.CurePartSetDataGrid.datagrid("getSelections");
		if((!rows)||(rows.length==0)){
			$.messager.alert("提示","请在右侧列表选择一行需要关联的部位/穴位行记录！",'warning');
			return false;
		}
		var PartId=[];
		for(var i=0;i<rows.length;i++){
			PartId.push(rows[i].CPSRowid)
		}
		var PartIdStr=PartId.join("^");
		var UserHospID=GetUserHospID();
		$cm({
			ClassName:"DHCDoc.DHCDocCure.BodySet",
			MethodName:"SavePartGrpLinkSet",
			CPGSRowid:CPGSRowid,
			PartIdStr:PartIdStr,
			HospID:UserHospID,
			dataType:"text"
		},function(ret){
			if(ret==0){
				$.messager.popover({msg: '保存成功',type:'success',timeout: 1000});
				CurePartGrpLinkSetDataGridLoad();
				var rowData = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected");
				CurePartSetDataGridLoad(rowData.CPGSRowid,rowData.CPGSTypeId)
			}else{
				$.messager.alert("提示",$g("保存失败:")+ret,'warning');
				return false;	
			}
		});
	}
}
function DeletePartGrpLinkSet(){
	var row = PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请在中间列表选择一行需要删除的已关联部位/穴位行记录！",'warning');
		return false;
	}else{
		$.messager.confirm("提示","是否确认删除?",function(r){
			if(r){
				var CPGLRowid=row.CPGLRowid;
				$.cm({
					ClassName:"DHCDoc.DHCDocCure.BodySet",
					MethodName:"DelPartGrpLinkSet",
					CPGLRowid:CPGLRowid,
					dataType:"text"
				},function(ret){
					if(ret==0){
						$.messager.popover({msg: '删除成功',type:'success',timeout: 1000});
						CurePartGrpLinkSetDataGridLoad();
						var rowData = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected");
						CurePartSetDataGridLoad(rowData.CPGSRowid,rowData.CPGSTypeId)
					}else{
						$.messager.alert("提示","删除失败:"+ret,'warning');
						return false;	
					}
				});
			}	
		})
	}
}
function UpPartGrpLinkSet(){
	MovePartGrpLinkSet("U");
}
function DownPartGrpLinkSet(){
	MovePartGrpLinkSet("D");
}
function MovePartGrpLinkSet(MoveType){
	var MoveTypeDesc=((MoveType=="U")?"上移":"下移");
	var row = PageLogicObj.CurePartGrpLinkSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		$.messager.alert("提示",$g("请在中间列表选择一行需要"+MoveTypeDesc+"的已关联部位/穴位行记录！"),'warning');
		return false;
	}else{
		var CPGLRowid=row.CPGLRowid;
		$.cm({
			ClassName:"DHCDoc.DHCDocCure.BodySet",
			MethodName:"MovePartGrpLinkSet",
			CPGLRowid:CPGLRowid,
			MoveType:MoveType,
			dataType:"text"
		},function(ret){
			if(ret==0){
				$.messager.popover({msg: MoveTypeDesc+'成功',type:'success',timeout: 1000});
				CurePartGrpLinkSetDataGridLoad(CPGLRowid);
			}else{
				if(ret==101){
					ret="无法继续"+	MoveTypeDesc;
				}
				$.messager.alert("提示",MoveTypeDesc+"失败:"+ret,'warning');
				return false;	
			}
		});
	}
}

function showImage(that) {
	//alert(e.id+","+e.src);
	if(typeof(that.src)=="undefined"){
		that.src=that.id;	
	}
	if(that.src==""){
		return	
	}
	const img = new Image();
	img.src = that.src;
	const newWin = window.open("", "_blank","height=600,width=1000,toolbar=0,location=0,directories=0,status=0,menubar=0,resizable=1,top=50,left=50");
	newWin.document.write(img.outerHTML);
	newWin.document.title = "图片详情"
	newWin.document.close();
}

function ReCureItemHandle(){
	var row = PageLogicObj.CurePartGrpSetDataGrid.datagrid("getSelected"); //PageLogicObj.CurePartGrpSetDataGrid.getSelections();
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行部位/穴位组行记录！",'warning')
	}else{
	    $("#refitem-dialog").css("display", ""); 
		var dialog = $HUI.dialog("#refitem-dialog",{
			autoOpen: false,
			iconCls:'icon-w-plus',
			height: 500,
			width: 400,
			modal: true
		});
		dialog.dialog("open");
		InitRefCureItemDataGrid(row["CPGSRowid"]);
	}
}

function InitRefCureItemDataGrid(Rowid){
	var CureToolBar = [{
	    text: '新增',
	    iconCls: 'icon-add',
	    handler: function() {
		    var mDataGtid=PageLogicObj.RefCureItemDataGrid;
	        if (PageLogicObj.editRefItemRow != undefined) {
	            $.messager.alert("提示", "有正在编辑的行，请先点击保存", "info");
	            return;
	        }else{
		        if(mDataGtid.datagrid("getRows").length == 0 ){
					mDataGtid.datagrid("options").pageNumber = 1;
				}
	            mDataGtid.datagrid("insertRow", {
	                index: 0,
	                row: {
						ExpRowID:"",
						CureItemRowID:"",
						CureItemDesc:"",						
					}
	            });
	            mDataGtid.datagrid("beginEdit", 0);
	            PageLogicObj.editRefItemRow = 0;
	        }
	      
	    }
	},{
	    text: '保存',
	    iconCls: 'icon-save',
	    handler: function() {
		    var mDataGtid=PageLogicObj.RefCureItemDataGrid;
	        if(PageLogicObj.editRefItemRow==undefined){
				return false;
		  	}
	        var rows = mDataGtid.datagrid("getRows");
			if (rows.length > 0){
			   for (var i = 0; i < rows.length; i++) {
				   if(PageLogicObj.editRefItemRow==i){
					   var rows=mDataGtid.datagrid("selectRow",PageLogicObj.editRefItemRow).datagrid("getSelected");  
					   var editors = mDataGtid.datagrid('getEditors', PageLogicObj.editRefItemRow); 
					   var CureItemRowID=editors[0].target.combobox('getValue');
					   if ((!CureItemRowID)||(rows.CureItemRowID=="")){
							$.messager.alert('提示',"请选择治疗项目!","info");
							return false;
			            }
						$.m({
							ClassName:"DHCDoc.DHCDocCure.CureItemSet",
							MethodName:"SaveCureItemSetExpVal",
							DDCISRowid:CureItemRowID,
							Key:"POAGRP",
							ExpVal:Rowid
						},function testget(value){
							if(value=="0"){
								PageLogicObj.RefCureItemDataGrid.datagrid("endEdit", PageLogicObj.editRefItemRow);
								PageLogicObj.editRefItemRow = undefined;
								RefCureItemDataGridLoad();
								$.messager.popover({type:"success",msg:"保存成功"});
							}else if(value=="-100"){
								$.messager.alert('提示',"请选择一个已激活的治疗项目!","warning");
								return false;
							}else if(value=="-101"){
								$.messager.alert('提示',"保存失败,"+value,"warning");
								return false;
							}else if(value=="Repeat"){
								$.messager.alert('提示',"数据重复.","warning");
								return false;
							}else{
								$.messager.alert('提示',"保存失败:"+value,"warning");
								return false;
							}
							PageLogicObj.editRefItemRow = undefined;
						});
				   }
			   }
			}
	    }
	}, {
	    text: '取消编辑',
	    iconCls: 'icon-redo',
	    handler: function() {
	        PageLogicObj.editRefItemRow = undefined;
	        PageLogicObj.RefCureItemDataGrid.datagrid("rejectChanges");
	        PageLogicObj.RefCureItemDataGrid.datagrid("unselectAll");
	    }
	},
	{
	    text: '删除',
	    iconCls: 'icon-cancel',
	    handler: function() {
	        var rows = PageLogicObj.RefCureItemDataGrid.datagrid("getSelections");
	        if (rows.length > 0) {
	            $.messager.confirm("提示", "确定删除吗?",
	            function(r) {
	                if (r) {
	                    var ids = [];
	                    for (var i = 0; i < rows.length; i++) {
	                        ids.push(rows[i].ExpRowID);
	                    }
	                    var RowID=ids.join(',');
	                    if (RowID==""){
	                        PageLogicObj.editRefItemRow = undefined;
			                PageLogicObj.RefCureItemDataGrid.datagrid("rejectChanges");
			                PageLogicObj.RefCureItemDataGrid.datagrid("unselectAll");
			                return;
	                    }
	                    $.m({
	                        ClassName:"DHCDoc.DHCDocCure.CureItemSet",
	                        MethodName:"DelCureItemSetExpVal",
	                        DDCExpRowid:RowID,
	                        dataType:"text"
	                    },function testget(value){
							if(value=="0"){
								RefCureItemDataGridLoad();
	           					$.messager.popover({type:"success",msg:"删除成功"});
							}else{
								$.messager.alert('提示',"删除失败:"+value,"warning");
							}
							PageLogicObj.editRefItemRow = undefined;
						});
	                }
	            });
	        } else {
	            $.messager.alert("提示", "请选择要删除的行", "info");
	        }
	     
	    }
	}];
	var RefCureItemColumns=[[    
		{ field: 'ExpRowID', title: 'ExpRowID', width: 1, align: 'left',hidden:true
		},
		{ field: 'CureItemRowID', title: 'CureItemRowID', width: 1, align: 'left',hidden:true
		},
		{ field: 'CureItemDesc', title: '治疗项目名称', width: 348, align: 'left',
		  editor:{
				type:'combogrid',
				options:{
					//required: true,
					panelWidth:300,
					panelHeight:350,
					idField:'DDCISRowid',
					textField:'ArcimDesc',
					value:'',
					mode:'remote',
					pagination : true,
					rownumbers:true,
					collapsible:false,  
					fit: true,
					pageSize: 10,
					pageList: [10],
					columns:[[
                        {field:'ArcimDesc',title:'名称',width:250,sortable:false},
	                    {field:'DDCISRowid',title:'DDCISRowid',width:120,sortable:true,hidden:true},
	                    {field:'selected',title:'selected',width:120,sortable:true,hidden:true}
                     ]],
                     onShowPanel:function(){
                        var trObj = $HUI.combogrid(this);
						var object1 = trObj.grid();
                     	LoadItemData("",object1)
                     },
					 onSelect:function(rowIndex, rowData){
						 var rows=PageLogicObj.RefCureItemDataGrid.datagrid("selectRow",PageLogicObj.editRefItemRow).datagrid("getSelected");
						 rows.CureItemRowID=rowData.DDCISRowid
					 },
					 onChange:function(Value,oldValue){
                		if (!Value) {
                    		 var rows=PageLogicObj.RefCureItemDataGrid.datagrid("selectRow",PageLogicObj.editRefItemRow).datagrid("getSelected");
						 	 rows.CureItemRowID="";
                    	}
                	},
					 keyHandler:{
						up: function () {
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    if (index > 0) {
			                        $(this).combogrid('grid').datagrid('selectRow', index - 1);
			                    }
			                } else {
			                    var rows = $(this).combogrid('grid').datagrid('getRows');
			                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
			                }
			             },
			             down: function () {
			               //取得选中行
			                var selected = $(this).combogrid('grid').datagrid('getSelected');
			                if (selected) {
			                    //取得选中行的rowIndex
			                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
			                    //向下移动到当页最后一行为止
			                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
			                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
			                    }
			                } else {
			                    $(this).combogrid('grid').datagrid('selectRow', 0);
			                }
			            },
						left: function () {
							return false;
			            },
						right: function () {
							return false;
			            },            
						enter: function () { 
						  	//文本框的内容为选中行的的字段内容
			                var selected = $(this).combogrid('grid').datagrid('getSelected');  
						    if (selected) { 
						      $(this).combogrid("options").value=selected.ArcimDesc;
						      var rows=PageLogicObj.RefCureItemDataGrid.datagrid("selectRow",PageLogicObj.editRefItemRow).datagrid("getSelected");
                              rows.CureItemRowID=selected.DDCISRowid;
						    }
			                //选中后让下拉表格消失
			                $(this).combogrid('hidePanel');
							$(this).focus();
			            },
						query:function(q){
							var object1=new Object();
							object1=$(this);
							var trObj = $HUI.combogrid(this);
							var object1 = trObj.grid();
							if (this.AutoSearchTimeOut) {
								window.clearTimeout(this.AutoSearchTimeOut)
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
							}else{
								this.AutoSearchTimeOut=window.setTimeout(function(){ LoadItemData(q,object1);},400); 
							}
							$(this).combogrid("setValue",q);
						}
        			}
        		}
			 }
		  
		}
	 ]];
	PageLogicObj.RefCureItemDataGrid=$('#tabRefCureItem').datagrid({  
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocCure.CureItemSet&QueryName=QueryCureItemExp&rows=99999",
		loadMsg : '加载中..',  
		pagination : true,
		rownumbers : true,
		idField:"ExpRowID",
		pageSize:10,
		pageList : [10,20],
		columns :RefCureItemColumns,
		toolbar :CureToolBar,
		onBeforeLoad:function(param){
			PageLogicObj.editRefItemRow = undefined;
			$(this).datagrid("unselectAll");
			var hospID=GetUserHospID();
			param = $.extend(param,{Key:"POAGRP",KeyVal:Rowid,HospId:hospID});
		}
	});
}

function RefCureItemDataGridLoad(){
	PageLogicObj.RefCureItemDataGrid.datagrid("reload");
}

function LoadItemData(q,obj){
	var hospID=GetUserHospID();
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindAllItem",
		Alias:q,CureItemFlag:"on",SubCategory:"",HospID:hospID,
		Pagerows:obj.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		obj.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}