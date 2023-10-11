// 导出表单
function ExportForm(FormID,FormName){
	
	var CPWInfo=$m({ClassName:"DHCMA.CPW.BTS.ExportPathWay",MethodName:"GetCPWInfo",aFormID:FormID},false); 
	var arrCPWInfo=eval('['+CPWInfo+']')
	
	var FormInfo=$m({ClassName:"DHCMA.CPW.BTS.ExportPathWay",MethodName:"GetFormInfo",aFormID:FormID},false); 
	var arrFormInfo=eval('['+FormInfo+']')
			
	var uri = 'data:application/vnd.ms-excel;base64,'
	var base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }

    var ctx = "";
    var workbookXML = "";
    var worksheetsXML = "";
    var rowsXML = "";
    
    for(var i=0;i<arrCPWInfo.length;i++){
    	var row=arrCPWInfo[i];
    	rowsXML += '<Row>';
    	rowsXML += '<Cell><Data ss:Type="String">'+row[0]+'</Data></Cell>';
    	rowsXML += '<Cell><Data ss:Type="String">'+htmlEncodeByRegExp(row[1])+'</Data></Cell>';
    	rowsXML += '</Row>'
    }
    worksheetsXML += '<Worksheet ss:Name="路径"><Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.4">'
			+'<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+'<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="279"/>'
			+rowsXML+'</Table></Worksheet>'
    
    
    var arrRowHight=[24,24,100,220,150]
    rowsXML = "";
    var FormInfoLen=arrFormInfo.length;
    for(var i=0;i<FormInfoLen;i++){
    	var row=arrFormInfo[i];
    	rowsXML = '<Column ss:Index="'+(FormInfoLen-i+1)+'" ss:AutoFitWidth="1" ss:Width="200"/>'+rowsXML;
    	rowsXML += '<Row ss:Height="'+arrRowHight[i]+'">';
    	
    	for(var j=0;j<row.length;j++){
    		rowsXML += '<Cell ss:StyleID="s60"><Data ss:Type="String">'+row[j]+'</Data></Cell>';
    	}
    	rowsXML += '</Row>'
    }
    worksheetsXML += '<Worksheet ss:Name="表单"><Table>'
			+rowsXML+'</Table></Worksheet>'
    
    workbookXML='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><?mso-application progid="Excel.Sheet"?>'
    		+'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">'
	        + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>DHCMA.CPW</Author><Created>'+(new Date()).getTime()+'</Created></DocumentProperties>'
	        + '<Styles>'
	        + '<Style ss:ID="s60"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/></Borders><Font ss:FontName="宋体" x:CharSet="134" ss:Size="10"/><NumberFormat/></Style>' 
	        + '</Styles>'
	        + worksheetsXML+'</Workbook>'
	
	var data=base64(workbookXML);
	var filename=FormName+ '.xls';
	if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, filename);
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = filename;
        alink[0].click();
        alink.remove();
    }
 }
 
 // 导出医嘱
 var objWB={};
 objWB.rowsXML="";
 function ExportOrd(FormID,FormName){
	
	var uri = 'data:application/vnd.ms-excel;base64,'
	var base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }

    var ctx = "";
    var workbookXML = "";
    var worksheetsXML = "";
    var rowsXML = "";
    
    var CPWInfo=$m({ClassName:"DHCMA.CPW.BTS.ExportPathWay",MethodName:"ExportOrd",aItmjs:"GetRowXML",aFormID:FormID},false);
    eval(CPWInfo)
    worksheetsXML += '<Worksheet ss:Name="临床路径表单"><Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.4">'
			+'<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="80"/>'
			+'<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="200"/>'
			+'<Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="80"/>'
			+'<Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="150"/>'
			+'<Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="150"/>'
			+objWB.rowsXML+'</Table></Worksheet>'
    
    workbookXML='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><?mso-application progid="Excel.Sheet"?>'
    		+'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">'
	        + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>DHCMA.CPW</Author><Created>'+(new Date()).getTime()+'</Created></DocumentProperties>'
	        + worksheetsXML+'</Workbook>'
	
	var data=base64(workbookXML);
	var filename=FormName+ '-医嘱.xls';
	if (window.navigator.msSaveBlob){
        var blob = b64toBlob(data);
        window.navigator.msSaveBlob(blob, filename);
    } else {
        var alink = $('<a style="display:none"></a>').appendTo('body');
        alink[0].href = uri + data;
        alink[0].download = filename;
        alink[0].click();
        alink.remove();
    }
    
    objWB.rowsXML="";
 }
function GetRowXML(){
	var xml="";
 	xml += '<Row>';
	for (var i = 0; i < arguments.length; i++) {
		xml += '<Cell><Data ss:Type="String">'+htmlEncodeByRegExp(arguments[i])+'</Data></Cell>';
	}
	xml += '</Row>';
	
	objWB.rowsXML += xml
 }

// 导出申请审核详情内容
function ExportApplyPubMsg(FormID){	
	// Edit Code...	
	//alert(obj.CurrForm.PathType+" "+ obj.CurrForm.PathDesc);
	
	//路径版本信息
    var objFormData = $cm({
		ClassName:"DHCMA.CPW.BTS.PathFormSrv",
		MethodName:"GetPathInfoByForm",
		aPathFormID:FormID
	},false)
	if (typeof objFormData !== 'object') return;
	var PathName = obj.CurrForm.PathDesc + '(V'+ objFormData.FormVer + '.0)'
	
	var uri = 'data:application/vnd.ms-excel;base64,'
	var base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }

    var ctx = "";
    var workbookXML = "";
    var worksheetsXML = "";
    var rowsXML = "";
	
	rowsXML += '<Row>';
	rowsXML += '<Cell><Data ss:Type="String">'+obj.CurrForm.PathType+'</Data></Cell>';
	rowsXML += '</Row>';
	rowsXML += '<Row>';
	rowsXML += '<Cell><Data ss:Type="String">'+PathName+'</Data></Cell>';
	rowsXML += '</Row>';
	rowsXML += '<Row>';
	rowsXML += '<Cell><Data ss:Type="String">查看审核详情</Data></Cell>';
	rowsXML += '</Row>';
	rowsXML += '<Row>';
	rowsXML += '<Cell><Data ss:Type="String">申请次数</Data></Cell>';
	rowsXML += '<Cell><Data ss:Type="String">意见或建议</Data></Cell>';
	rowsXML += '<Cell><Data ss:Type="String">审核部门</Data></Cell>';
	rowsXML += '<Cell><Data ss:Type="String">审核人员</Data></Cell>';
	rowsXML += '<Cell><Data ss:Type="String">审核时间</Data></Cell>';
	rowsXML += '<Cell><Data ss:Type="String">审核情况</Data></Cell>';
	rowsXML += '</Row>'; 
	
	// 循环历次申请并获取历次申请下各角色审核明细
	$cm({
		ClassName:"DHCMA.CPW.BTS.ApplyExamRecSrv",
		MethodName:"GetAllApplyRec",
		aFomrID:FormID
	},function(applyData){
		if (applyData.length == 0) return
		for(var i=0;i<applyData.length;i++){
	    	var cellApplyInfo = ""
	    	var row = applyData[i];
	    	cellApplyInfo = "第" + ( i + 1 ) + "次申请"
	    	cellApplyInfo = cellApplyInfo + "【" + row.IsFinPass + "/" + row.ApplyDate + " " + row.ApplyTime + "/" + row.ApplyLoc + "/" + row.ApplyUser + "】"
	    	rowsXML += '<Row>';
	    	rowsXML += '<Cell ss:StyleID="s61"><Data ss:Type="String">' + cellApplyInfo + '</Data></Cell>';
	    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
	    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
	    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
	    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
	    	rowsXML += '<Cell ss:StyleID="s63"><Data ss:Type="String">' + '' + '</Data></Cell>';
	    	rowsXML += '</Row>'
	    	
	    	// 获取该次申请审核详情
			var dtlData = $cm({
				ClassName:"DHCMA.CPW.BTS.ApplyExamRecSrv",
				MethodName:"GetMsgOpinion",
				aApplyRecID:row.RecID
			},false)
			
			if (dtlData.length == 0) return
			var cellExamOpn = "",cellExamRole,cellExamUser,cellExamDate,cellExamResult = ""
			for(var j=0;j<dtlData.length;j++){
				var row = dtlData[j];
				cellExamOpn = htmlEncodeByRegExp(row.txtOpinion)
				cellExamRole = row.RoleName
				cellExamUser = row.UserName
				cellExamDate = row.ExamDate + " " + row.ExamTime
				cellExamResult = row.ExamResult
				rowsXML += '<Row>';
		    	rowsXML += '<Cell><Data ss:Type="String">' + "" + '</Data></Cell>';
		    	rowsXML += '<Cell><Data ss:Type="String">' + cellExamOpn + '</Data></Cell>';
		    	rowsXML += '<Cell><Data ss:Type="String">' + cellExamRole + '</Data></Cell>';
		    	rowsXML += '<Cell><Data ss:Type="String">' + cellExamUser + '</Data></Cell>';
		    	rowsXML += '<Cell><Data ss:Type="String">' + cellExamDate + '</Data></Cell>';
		    	rowsXML += '<Cell ss:StyleID="s64"><Data ss:Type="String">' + cellExamResult + '</Data></Cell>';
		    	rowsXML += '</Row>'
			}
	    }

		var cellVerUser = objFormData.VerUser
		var cellVerDate = objFormData.VerDate
		var cellVerTime = objFormData.VerTime
		if (cellVerTime != "") cellVerDate = cellVerDate + " " + cellVerTime
		var cellVerStatus = ""
		if (parseInt(objFormData.IsVaild)!=1){
			cellVerStatus = "已作废"
		}else{
			if (parseInt(objFormData.IsOpen)==1) cellVerStatus = "已发布"
			else cellVerStatus = "未发布"	
		}
		
	    rowsXML += '<Row>';
    	rowsXML += '<Cell ss:StyleID="s61"><Data ss:Type="String">' + '发布时间' + '</Data></Cell>';
    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + '' + '</Data></Cell>';
    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + cellVerUser + '</Data></Cell>';
    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + cellVerDate + '</Data></Cell>';
    	rowsXML += '<Cell ss:StyleID="s62"><Data ss:Type="String">' + cellVerStatus + '</Data></Cell>';
    	rowsXML += '</Row>'	    
	    
	    worksheetsXML += '<Worksheet ss:Name="申请及审核详情"><Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="100" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="54" ss:DefaultRowHeight="14.4">'
			+'<Column ss:Index="1" ss:AutoFitWidth="0" ss:Width="300"/>'
			+'<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="350"/>'
			+'<Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+'<Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+'<Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+'<Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="84.6"/>'
			+rowsXML+'</Table></Worksheet>'
		
		workbookXML='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><?mso-application progid="Excel.Sheet"?>'
	    		+'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">'
		        + '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office"><Author>DHCMA.CPW</Author><Created>'+(new Date()).getTime()+'</Created></DocumentProperties>'
		        + '<Styles>'
		        + '<Style ss:ID="s61"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/></Borders></Style>'
		        + '<Style ss:ID="s62"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/></Borders></Style>'
		        + '<Style ss:ID="s63"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/><Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/></Borders></Style>'
		        + '<Style ss:ID="s64"><Alignment ss:Vertical="Top" ss:WrapText="1"/><Borders><Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/></Borders></Style>'
		        + '</Styles>'
		        + worksheetsXML+'</Workbook>'
		
		var data=base64(workbookXML);
		var filename=PathName+'审核详情.xls';
		if (window.navigator.msSaveBlob){
	        var blob = b64toBlob(data);
	        window.navigator.msSaveBlob(blob, filename);
	    } else {
	        var alink = $('<a style="display:none"></a>').appendTo('body');
	        alink[0].href = uri + data;
	        alink[0].download = filename;
	        alink[0].click();
	        alink.remove();
	    }
	    	
	})
}


// 以下为公共方法
function htmlEncodeByRegExp(str){
	var temp = "";
	if(str.length == 0) return "";
	temp = str.replace(/&/g,"&amp;");
	temp = temp.replace(/</g,"&lt;");
	temp = temp.replace(/>/g,"&gt;");
	temp = temp.replace(/\s/g,"&nbsp;");
	temp = temp.replace(/\'/g,"&#39;");
	temp = temp.replace(/\"/g,"&quot;");
    return temp;
}

function b64toBlob(data){
    var sliceSize = 512;
    var chars = atob(data);
    var byteArrays = [];
    for(var offset=0; offset<chars.length; offset+=sliceSize){
        var slice = chars.slice(offset, offset+sliceSize);
        var byteNumbers = new Array(slice.length);
        for(var i=0; i<slice.length; i++){
            byteNumbers[i] = slice.charCodeAt(i);
        }
        var byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
    }
    return new Blob(byteArrays, {
        type: 'application/vnd.ms-excel'
    });
}