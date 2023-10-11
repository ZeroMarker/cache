/*
治疗申请部位/穴位
app.apply.part.js
*/
var PartLogicObj={
	CspName:"doccure.apply.part.hui.csp",
	m_CurePartListDataGrid:"",
	m_CurePartGrpListDataGrid:"",
	m_LoadTimer:"",
	SelectedKey:"",
	InitShowGrp:"" //Y:关键字默认选中"穴位/部位组"? 
}
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	InitPartKey();
	PartLogicObj.m_CurePartListDataGrid=InitCurePartListDataGrid();
}

function InitEvent(){
	$HUI.radio("[name='PartOrAcupoint']",{
        onCheckChange:function(e,value){
	        clearTimeout(PartLogicObj.m_LoadTimer);
	        PartLogicObj.m_LoadTimer=setTimeout(function(){LoadListGridData()},100);
        }
    });	
    $HUI.radio("[name='PartOrAcupointGrp']",{
        onCheckChange:function(e,value){
            clearTimeout(PartLogicObj.m_LoadTimer);
	        PartLogicObj.m_LoadTimer=setTimeout(function(){LoadListGridData()},100);
        }
    });	
    
    $("#SaveCurPart").click(function(){SaveCurPart();})
    $("#SaveCurPartGrp").click(function(){SaveCurPart();})
}
function PageHandle(){
	$("#CurePartGrp").hide();
	$("#CurePart").show();
	if(PartLogicObj.InitShowGrp=="Y"){
		$("#PartKey").keywords("select","PartGrp");
		PartLogicObj.SelectedKey="PartGrp";
	}else{
		PartLogicObj.SelectedKey="Part";
	}
}

function InitPartKey(){
		var KeyWordsArr=[
			{text:$g('单穴位/部位'),id:"Part",selected:true},
			{text:$g('穴位/部位组'),id:"PartGrp"}
		]
		$("#PartKey").keywords({
		    singleSelect:true,
		    labelCls:'red',
		    items:KeyWordsArr,
		    onClick:function(o){
			   	var id=o.id;
			   	//debugger
			   	if(PartLogicObj.SelectedKey!=id){
				   	GridToggle();
				}
				PartLogicObj.SelectedKey=id;
			   	if(id=="Part"){
			    	LoadPartListGridData();
			   	}else{
				   	if(PartLogicObj.m_CurePartGrpListDataGrid==""){
			    		PartLogicObj.m_CurePartGrpListDataGrid=InitCurePartGrpListDataGrid();
				   	}else{
					   	LoadPartGrpListGridData();
					}
			    	
			   	}
			}
		});	
}

function GridToggle(){
	$("#CurePart").toggle();
	$("#CurePartGrp").toggle();	
}

function InitCurePartListDataGrid(){
	var CurePartDataGrid=$('#tabCurePartList').datagrid({ 
		//view:scrollview, 
		fit : true,
		width : 'auto',
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPartSetConfig&SActiveFlag=Y&rows=9999",
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : false,
		autoRowHeight : true,
		nowrap: true,
		collapsible:false,
		loadMsg : $g('加载中..'),  
		pagination:false,
		rownumbers : false,
		idField:"CPSRowid",
		pageSize : 20,
		pageList : [20,50],
		columns :[[ 
			//{ field:'SeqNumber',title:'',width:'40',align:'left'}, 
			{ field:'RowCheck',checkbox:true}, 
			{ field:'CPSRowid',title:'CPSRowid',width:20,align:'left', hidden: true},  
			{ field:'CPSDesc',title:'名称',width:150,align:'left', resizable: true},
			{ field:'CPSType', title:'类型', width: 60, sortable: true},
			{ field:'AcupPosition', title: '定位', width: 200, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupAttending', title: '主治', width: 220, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupOperation', title: '操作', width: 220, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupImg', title: '图解', width: 135, resizable: true
				,formatter:function(value,row,index){
					var html=formatterImg(row,index,"AcupImg");
					return html;
				}
			},
			{ field:'ImgDiagram', title: '图解base64', width: 100, hidden: true},
			{ field:'CPSDefaultFlag', title: '默认', width: 60}
		]],
		//toolbar:mtbar,
		onBeforeLoad:function(param){
			$(this).datagrid("clearSelections");
			var Type="";
			var checkedRadioObj = $("input[name='PartOrAcupoint']:checked");
			if(checkedRadioObj.length>0)Type=checkedRadioObj.val();
			var SDesc=$("#SDesc").searchbox("getValue");
			var NeedAcupDetail="Y";
			var ExpStr=NeedAcupDetail+"^"+ServerObj.DDCISRowid+"^"+PartLogicObj.CspName;
			$.extend(param,{Type:Type,SDesc:SDesc,HospID:session['LOGON.HOSPID'],ExpStr:ExpStr});
		},
		onLoadSuccess:function(data){
			//setTimeout(function(){StartImgLoading(data,0,"AcupImg");},50)
			if(ServerObj.ItemPOAInfo!=""){
				var POAObjArr=JSON.parse(ServerObj.ItemPOAInfo); 
				for(var i=0;i<POAObjArr.length;i++){
					var CPSRowid=POAObjArr[i].CPSRowid;
					$(this).datagrid("selectRecord",CPSRowid);	
				}
			}else{
				for (RowIndex=0;RowIndex<data.rows.length;RowIndex++){
					var CPSDefaultFlag=data.rows[RowIndex].CPSDefaultFlag;
					if(CPSDefaultFlag==$g("是")){
						$(this).datagrid("checkRow",RowIndex);
					}
				}
			}
			StartImgLoading(data,0,"AcupImg");
		}
	});
	return CurePartDataGrid;	
}

function InitCurePartGrpListDataGrid(){
	var CurePartGrpListObj=$HUI.treegrid("#tabCurePartGrpList",{
		fit : true,
		width : 'auto',
		url : $URL+"?ClassName=DHCDoc.DHCDocCure.BodySet&QueryName=QueryPOATreeConfig&rows=9999",
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		selectOnCheck:true,
		autoSizeColumn:false,
		checkbox:true,
		fitColumns : false,
		autoRowHeight : true,
		nowrap: true,
		collapsible:false,
		loadMsg : $g('加载中..'),  
		pagination : false,
		rownumbers : false,
		idField:"CPSRowid",
		treeField:'CPSDesc',
		pageSize : 5,
		pageList : [5,20,50],
		columns :[[ 
			//{ field:'RowCheck',checkbox:true}, 
			//{ field:'SeqCount',title:'序号',width:'40',align:'left'}, 
			{ field:'CPSRowid',title:'CPSRowid',width:20,align:'left', hidden: true}, 
			{ field:'CPSDesc',title:'组名称',width:180,align:'left', resizable: true},
			{ field:'CPSType', title:'类型', width: 60, sortable: true}, 
			{ field:'AcupPosition', title: '定位', width: 240, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupAttending', title: '主治', width: 240, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupOperation', title: '操作', width: 240, resizable: true,
				formatter:function(value,row,index){
					var value=formatter(value);
					return value;
				}
			},
			{ field:'AcupImg', title: '图解', width: 135, resizable: true
				,formatter:function(value,row,index){
					var html=formatterImg(row,index,"AcupImgGrp");
					return html;
				}
			},
			{ field:'ImgDiagram', title: '图解base64', width: 100, hidden: true},
			{ field:'CPSDefaultFlag', title: '默认', width: 60,hidden:true}
		]],
		//toolbar:mtbar,
		onBeforeLoad:function(row,param){
			$HUI.treegrid("#tabCurePartGrpList").unselectAll();
			var Type="";
			var checkedRadioObj = $("input[name='PartOrAcupointGrp']:checked");
			if(checkedRadioObj.length>0)Type=checkedRadioObj.val();
			var SDesc=$("#SGrpDesc").searchbox("getValue");
			var SessionStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'];
			var SessionStr=SessionStr+"^"+session['LOGON.LANGID']+"^"+PartLogicObj.CspName
			$.extend(param,{DDCISRowid:ServerObj.DDCISRowid,Type:Type,SDesc:SDesc,SessionStr:SessionStr});
		},
		onLoadSuccess:function(row,data){
			//setTimeout(function(){StartImgLoading(data,0,"AcupImgGrp");},3000)
			if(ServerObj.ItemPOAInfo!=""){
				var POAObjArr=JSON.parse(ServerObj.ItemPOAInfo); 
				for(var i=0;i<POAObjArr.length;i++){
					var CPSRowid=POAObjArr[i].CPSRowid;
					$(this).treegrid("checkNode",CPSRowid);	
				}
			}else{
				for (RowIndex=0;RowIndex<data.rows.length;RowIndex++){
					var row=data.rows[RowIndex];
					var CPSDefaultFlag=row.CPSDefaultFlag;
					if(CPSDefaultFlag==$g("是")){
						var CPSRowid=row.CPSRowid;
						$(this).treegrid("checkNode",CPSRowid);
					}
				}
			}
			StartImgLoading(data,0,"AcupImgGrp")
		}
	});
	return CurePartGrpListObj;
}

function StartImgLoading(data,StartRow,key){
	var myArr=[];
	for (RowIndex=0;RowIndex<data.rows.length;RowIndex++){
		var ImgDiagram=data.rows[RowIndex].ImgDiagram;
		if(ImgDiagram!=""){
			var CPSRowid=data.rows[RowIndex].CPSRowid;
			var mPromise=new Promise(function(resolve,rejected){
				$("#"+key+"_"+CPSRowid).attr("src",ImgDiagram);
			}).then(function(){
				//document.body.appendChild(image)
			})
			myArr.push(mPromise);
		}
	}
	if(myArr.length>0){
		Promise.all(myArr);
	}
}

function LoadPartListGridData(){
	PartLogicObj.m_CurePartListDataGrid.datagrid("reload");
}

function LoadPartGrpListGridData(){
	PartLogicObj.m_CurePartGrpListDataGrid.reload();
}

function LoadListGridData(){
	var KeyObj=$("#PartKey").keywords("getSelected");
	var id=KeyObj[0].id;
	if(id=="Part"){
		LoadPartListGridData();	
	}else{
		LoadPartGrpListGridData();
	}
}

function formatter(value){
	return value.replace(new RegExp("\n","g"),"</br>");
}

function formatterImg(row,index,key){
	if(row.ImgDiagram!=""){
		var html='<img id="'+key+'_'+row.CPSRowid+'" alt="暂无图解" onclick="showImage(this)" style="width:120px;height:120px" src="'+""+'" title="点击图片查看大图">'
	}else{
		var html="";
	}
	return html;
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
	newWin.document.title = $g("图片详情")
	newWin.document.close();
}

function SaveCurPart(){
	var CurPartArr=[];
	var KeyObj=$("#PartKey").keywords("getSelected");
	var id=KeyObj[0].id;
	if(id=="Part"){
		var rows=PartLogicObj.m_CurePartListDataGrid.datagrid("getSelections");
		if(rows.length>0){
			for(var i=0;i<rows.length;i++){
				var CPSRowid=rows[i].CPSRowid;
				var obj={
					CPSRowid:CPSRowid,
					CPGSRowid:""	
				}
				CurPartArr.push(obj);
			}
			CloseWin(JSON.stringify(CurPartArr));
		}else{
			$.messager.confirm("提示","您未选择需要保存的信息,是否继续？",
				function(r){
					if(r){
						CloseWin("");
					}else{
						return false;	
					}
			})
		}
	}else{
		var rows=PartLogicObj.m_CurePartGrpListDataGrid.getCheckedNodes('checked');
		if(rows.length>0){
			for(var i=0;i<rows.length;i++){
				var CPSRowid=rows[i].CPSRowid;
				var _parentId=rows[i]._parentId;
				if(_parentId!=""){
					var obj={
						CPSRowid:CPSRowid,
						CPGSRowid:_parentId	
					}
					CurPartArr.push(obj);
				}
			}
			CloseWin(JSON.stringify(CurPartArr));
		}else{
			$.messager.confirm("提示","您未选择需要保存的信息,是否继续？",
				function(r){
					if(r){
						CloseWin("")
					}else{
						return false;	
					}
			})
		}
	}
	function CloseWin(rtn){
		websys_showModal("hide");
		if(websys_showModal('options')&&(websys_showModal('options').AddPOAInfo)){
			websys_showModal('options').AddPOAInfo(rtn);
		}
		websys_showModal("close");
	}
}