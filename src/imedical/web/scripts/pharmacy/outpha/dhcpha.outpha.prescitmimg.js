function ChangGridCols(_opt){
	var changFlag=_opt.changFlag;
	var _fn=_opt.initGrid;
	if(changFlag % 2 == 1){
		if(_fn==undefined){
			return;
		}
		_fn();
		return;
	}
	
	var $grid=$('#'+_opt.gridName);
	var gridOption = $grid.datagrid("options")
	var gridUrl = gridOption.url;
	
	var columns=[[{	
			title:'ҩƷ1',
			align:'left',
			colspan:3
		},{	
			title:'ҩƷ2',
			align:'left',
			colspan:3
		},{	
			title:'ҩƷ3',
			align:'left',
			colspan:3
		}],[
		{
			title:'ͼƬ1',
			field:'img1',
			width:200,
			formatter: StyleImg,
			align:'left'

        },
		{
			title:'����1',
			field:'list1',
			width:70,
			align:'left'
        },
		{
			title:'����1',
			field:'desc1',
			width:70,
			align:'left'
        },
		{
			title:'ͼƬ2',
			field:'img2',
			width:200,
			formatter: StyleImg,
			align:'left'
        },
		{
			title:'����2',
			field:'list2',
			width:70,
			align:'left'
        },
		{
			title:'����2',
			field:'desc2',
			width:70,
			align:'left'
        },
		{
			title:'ͼƬ3',
			field:'img3',
			width:200,
			formatter: StyleImg,
			align:'left'
        },
		{
			title:'����3',
			field:'list3',
			width:70,
			align:'left'
        },
		{
			title:'����3',
			field:'desc3',
			width:70,
			align:'left'
			
        }
	]];
	var gridUrl="/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.COM.Store&MethodName=JsGetPrescItm"
	var dataGridOption={
	    columns: columns, //��
	    url:gridUrl,
		fitColumns:true,
		pagination:false,
		onLoadSuccess: function () {
         	var gridName = _opt.gridName;
            GridMerger(gridName, 'img1');
            GridMerger(gridName, 'list1');
            GridMerger(gridName, 'desc1')
            GridMerger(gridName, 'img2');
            GridMerger(gridName, 'list2');
            GridMerger(gridName, 'desc2')
            GridMerger(gridName, 'img3');
            GridMerger(gridName, 'list3');
            GridMerger(gridName, 'desc3');
            
		},
		onClickCell:function(rowIndex,field,value){
			if(field.indexOf("img")>-1){
				console.log(value)
				ReplaceImg(rowIndex,field,value)
			}
		}
	};
	$grid.dhcphaEasyUIGrid(dataGridOption);

}
//�������÷���
function GridMerger(gridName, CellName) {
    //�õ���ʾ�������id����
    var mya = $("#" + gridName + "").datagrid("getRows");
    //��ǰ��ʾ������
    var length = mya.length;
    for (var i = 0; i < length; i++) {
        //���ϵ��»�ȡһ����Ϣ
        var before = mya[i];
        //����ϲ�����
        var rowSpanTaxCount = 1;
        for (j = i + 1; j <length; j++) {
            //���ϱߵ���Ϣ�Ա� ���ֵһ���ͺϲ�����+1 Ȼ������rowspan �õ�ǰ��Ԫ������
            var end = mya[j];
            if (before[CellName] == end[CellName]) {
                rowSpanTaxCount++;
            } else {
                break;
            }
        }
        if(rowSpanTaxCount>1){
            var opt={
                	index:i,
                	field:CellName,
                	rowspan:rowSpanTaxCount,
                	colspan:0
                }
        	$("#" + gridName + "").datagrid("mergeCells",opt);
        	i=j-1;
        }
    }
}
function StyleImg(value, rowData, rowIndex){
	var jsonFlag=isJSON(value);
	var html="";
	if(jsonFlag==true){
		var imgId="img"+this.field+"."+rowIndex;
		var objImg=JSON.parse(value);
		html='<div style="width:100%,heitht:100%,text-align:center">';
	    var imgNum=objImg.length;
	    for(var j=0;j<imgNum;j++){
		    if(j==1)break;
			var imgName=objImg[j].docName;
			if(imgName!=""){
				var imgFile=GetHttpFile(imgName);
				if(imgFile==""){
					imgFile="../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
				}
				if(html==""){
					html='<img id='+imgId+' title='+imgName+' src='+imgFile+' width="auto" height="auto"/>';
					break;
				}else{
					html=html+'<img id='+imgId+' title='+imgName+' src='+imgFile+' width="200" height="auto"/>'
				}
			}
		}
		html=html+'</div>'
	}
	else{
		html=value;
	}
	return html;
	        
}
function ReplaceImg(rowIndex,field,value) {
    var jsonFlag=isJSON(value);
	if(jsonFlag==true){
		var objImg=JSON.parse(value);
		var imgId="img"+field+"."+rowIndex;
		var obj = document.getElementById(imgId);
		var title=obj.title;
	    var imgNum=objImg.length;
	    var curNum=0
	    var curName="";
	    for(var j=0;j<imgNum;j++){
			var imgName=objImg[j].docName;
			if(imgName==title){
				curNum=j+1;
				if(curNum==imgNum){
					curNum=0;
				}
				curName=objImg[curNum].docName;
			};
	    }
	    if(curName==""){return}
	    var imgFile=GetHttpFile(curName);
		if(imgFile==""){
			imgFile="../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
		}
		obj.src = imgFile;
		obj.title = curName;
	}
}
function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if(typeof obj == 'object' && obj ){
                return true;
            }else{
                return false;
            }
        }catch(e) {
            return false;
        }
    }
}


//��ʼ����ҩ��ϸtable
function InitJqGirdPrescDetail(_opt){
	var changFlag=_opt.changFlag;
	var _fn=_opt.initGrid;
	var $grid=$('#'+_opt.gridName);
	var tmppostData=$('#'+_opt.gridName).jqGrid('getGridParam', "postData");
	if(changFlag % 2 == 1){
		if(_fn==undefined){
			return;
		}
		$grid.GridUnload()
		_fn();
		$('#'+_opt.gridName).setGridParam({
			datatype: 'json',
			postData: tmppostData
		}).trigger("reloadGrid");
		return;
	}
	
	
	var gridHeight=_opt.gridHeight;
	if(gridHeight==undefined){
		gridHeight=DhcphaJqGridHeight(2,3)*0.5;
	}
	$grid.GridUnload()
	
	var columns=[
		{
			header:'ͼƬ1',
			index:'img1',
			name:'img1',
			width:200,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'img1' + rowId + "\'" ;//+ 'style="color:red"';
            }
        },
		{
			header:'����1',
			index:'list1',
			name:'list1',
			width:70,
			
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'list1' + rowId + "\'";
            }
        },
		{
			header:'����1',
			index:'desc1',
			name:'desc1',
			width:70,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'desc1' + rowId + "\'";
            }
        },
		{
			header:'ͼƬ2',
			index:'img2',
			name:'img2',
			width:200,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'img2' + rowId + "\'";
            }
        },
		{
			header:'����2',
			index:'list2',
			name:'list2',
			width:70,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'list2' + rowId + "\'";
            }
        },
		{
			header:'����3',
			index:'desc2',
			name:'desc2',
			width:70,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'desc2' + rowId + "\'";
            }
        },
		{
			header:'ͼƬ3',
			index:'img3',
			name:'img3',
			width:200,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'img3' + rowId + "\'";
            }
        },
		{
			header:'����3',
			index:'list3',
			name:'list3',
			width:70,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'list3' + rowId + "\'";
            }
        },
		{
			header:'����3',
			index:'desc3',
			name:'desc3',
			width:70,
			cellattr: function(rowId, tv, rawObject, cm, rdata) {
               //�ϲ���Ԫ��
               return 'id=\'desc3' + rowId + "\'";
            }
        }
	]; 
	var jqOptions={
	    colModel: columns, //��
	    url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+'?action=GetPrescDetail',
	    height: gridHeight-34-12,
	    shrinkToFit:true,	
	    rowNum:200,
	    datatype:'local', 
        gridComplete: function() {
            //����gridComplete���úϲ�����
            
            var gridName = _opt.gridName;
            JqGridMerger(gridName, 'img1');
            JqGridMerger(gridName, 'list1');
            JqGridMerger(gridName, 'desc1');
            JqGridMerger(gridName, 'img2');
            JqGridMerger(gridName, 'list2');
            JqGridMerger(gridName, 'desc2');
            JqGridMerger(gridName, 'img3');
            JqGridMerger(gridName, 'list3');
            JqGridMerger(gridName, 'desc3');
            
            JqGridReplaceImg(gridName, 'img1');
            JqGridReplaceImg(gridName, 'img2');
            JqGridReplaceImg(gridName, 'img3');
            
        },
        onCellSelect:function(rowid,iCol,cellcontent,e){
	    	
		    var colModelArr=$("#" + _opt.gridName).jqGrid('getGridParam','colModel')
		    var field=colModelArr[iCol].index;
		    if(field.indexOf("img")>-1){
		    	var rowIndex=rowid-1;
		    	var imgId="img"+field+"."+rowIndex;
		    	var obj = document.getElementById(imgId);
		    	if(obj){
			    	var ImgValue=obj.name;
			    	var jsonFlag=isJSON(ImgValue);
					if(jsonFlag==true){
						var objImg=JSON.parse(ImgValue);
						var title=obj.title;
					    var imgNum=objImg.length;
					    var curNum=0
					    var curName="";
					    for(var j=0;j<imgNum;j++){
							var imgName=objImg[j].docName;
							if(imgName==title){
								curNum=j+1;
								if(curNum==imgNum){
									curNum=0;
								}
								curName=objImg[curNum].docName;
							};
					    }
					    if(curName==""){return}
					    var imgFile=GetHttpFile(curName);
						if(imgFile==""){
							imgFile="../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
						}
						obj.src = imgFile;
						obj.title = curName;
					}
		    	}
			}
			
	    }
		
	};
	$('#'+_opt.gridName).dhcphaJqGrid(jqOptions);
	$('#'+_opt.gridName).setGridParam({
		datatype: 'json',
		postData: tmppostData
	}).trigger("reloadGrid");

	$('#'+_opt.gridName).jqGrid('setGroupHeaders', {
	  useColSpanStyle:true,
	  
	  groupHeaders : [
				{ "startColumnName":'img1', "numberOfColumns":3, "titleText":'ҩƷ1','align':"center" },
				{ "startColumnName":'img2', "numberOfColumns":3, "titleText":'ҩƷ2' ,'align':"center"},
				{ "startColumnName":'img3', "numberOfColumns":3, "titleText":'ҩƷ3','align':"center" }
	  ]
	});
	//$("table.ui-jqgrid-htable", document.getElementById(_opt.gridName).grid.hDiv).find(".jqg-first-row-header").empty();
	//$("table.ui-jqgrid-htable", document.getElementById(_opt.gridName).grid.hDiv).find(".jqg-first-row-header").css("display","none");
	//PhaGridFocusOut(_opt.gridName);
	/**/
}

//�������÷���
function JqGridMerger(gridName, CellName) {
    //�õ���ʾ�������id����
    var mya = $("#" + gridName + "").getDataIDs();
    //��ǰ��ʾ������
    var length = mya.length;
    for (var i = 0; i < length; i++) {
        //���ϵ��»�ȡһ����Ϣ
        var before = $("#" + gridName + "").jqGrid('getRowData', mya[i]);
        //����ϲ�����
        var rowSpanTaxCount = 1;
        for (j = i + 1; j <= length; j++) {
            //���ϱߵ���Ϣ�Ա� ���ֵһ���ͺϲ�����+1 Ȼ������rowspan �õ�ǰ��Ԫ������
            var end = $("#" + gridName + "").jqGrid('getRowData', mya[j]);
            if (before[CellName] == end[CellName]) {
                rowSpanTaxCount++;
                $("#" + gridName + "").setCell(mya[j], CellName, '', { display: 'none' });
            } else {
                break;
            }
        }
        if(rowSpanTaxCount>1){
            $("#" + CellName + "" + mya[i] + "").attr("rowspan", rowSpanTaxCount);
        	i=j-1;
        }
    }

}
function JqGridReplaceImg(gridName, CellName) {
    //�õ���ʾ�������id����
    var mya = $("#" + gridName + "").getDataIDs();
    //��ǰ��ʾ������
    var length = mya.length;
    for (var i = 0; i <length; i++) {
	    var rowData = $("#" + gridName + "").jqGrid('getRowData', mya[i]);
	    var value=$("#" + gridName + "").jqGrid('getRowData', mya[i])[CellName];
	    var jsonFlag=isJSON(value);
	    var html=""
		if(jsonFlag==true){
			var imgId="img"+CellName+"."+i;
			var objImg=JSON.parse(value);
			html='<div style="width:100%,heitht:100%,text-align:center">';
		    var imgNum=objImg.length;
		    for(var j=0;j<imgNum;j++){
			    if(j==1)break;
				var imgName=objImg[j].docName;
				if(imgName!=""){
					var imgFile=GetHttpFile(imgName);
					if(imgFile==""){
						imgFile="../scripts_lib/hisui-0.1.0/dist/css/icons/big/paper.png";
					}
					if(html==""){
						html='<img id='+imgId+' title='+imgName+' name='+value+' src='+imgFile+' width="100%" height="100%"/>';
						break;
					}else{
						html=html+'<img id='+imgId+' title='+imgName+' name='+value+' src='+imgFile+' width="200" height="auto"/>'
					}
				}
			}
			html=html+'</div>'
		}
	    if(html!=""){
			$("#" + gridName + " #"+CellName+(i+1)).html(html);
 		    
		}
    }
}







function QueryDetailOrders(_opt){
	var grid=_opt.gridName;
	var changFlag=_opt.changFlag;
	if(changFlag==undefined){return;}
	if(changFlag % 2 == 1){
		return;
	}
	var gridType=_opt.gridType;
	var rowsData;
	if (gridType=="Eayui"){
		rowsData=$("#"+grid).datagrid('getRows');
	}
	else{	
	var rowsData = $("#"+grid).jqGrid('getRowData');
	}
	var rowsLen = rowsData.length;
	if (rowsLen <= 0) {
		$('#pha-orders-preview').html('');
		return;
	}
	var previewRows=[];
	for (var i = 0; i < rowsLen; i++) {
		var rowData = rowsData[i];
		var RealQty=rowData.TRealQty;
		if(RealQty==undefined){
			RealQty=rowData.TPhQty;
		}
		var inciId=rowData.TInci;
		var imgFile;
		var imgData=tkMakeServerCall("PHA.OP.COM.Method", "GetDrugDoc", inciId,1,"P")
		var imgJson=JSON.parse(imgData);
		var docName=imgJson.docName;
		if("undefined"!=typeof docName){imgFile=docName[0];}
		var sp = parseFloat(rowData.TPrice) ;
		var spamt = parseFloat(rowData.TMoney) ;
		var newRow={
			inciDesc: rowData.TPhDesc,
			qty:RealQty + rowData.TPhUom,
			inciAddInfo:rowData.TPhgg + ' | ' + rowData.TPhFact,
			instrucDesc:rowData.TYF,
			freqDesc:rowData.TPC,
			dosage:rowData.TJL,
			docRemark:rowData.TPhbz,
			invno:rowData.TPrtNo,
			stkbin:rowData.TIncHW,
			saleprice:sp,
			spamt:spamt,
			detailstatue:rowData.TPhDispItmStat,
			stkqty:rowData.TKCQty,
			medImg:imgFile   //'https://gitee.com/yunhaibao/picgo/raw/master/img/image-20210621124856392.png'
		}
		previewRows.push(newRow);
	}
    var template = $('#tempOrders').html();
    var handler = Handlebars.compile(template);
    $('#pha-orders-preview').html(handler({rows:previewRows}));
}
