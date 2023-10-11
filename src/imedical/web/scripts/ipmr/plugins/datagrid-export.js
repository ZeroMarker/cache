(function($){
    function getRows(target){
        var state = $(target).data('datagrid');
        if (state.filterSource){
            return state.filterSource.rows;
        } else {
            return state.data.rows;
        }
    }
    function getFooterRows(target){
        var state = $(target).data('datagrid');
        return state.data.footer || [];
    }

	function serverDataToHtml(target,columns,filename) {
		datagrid_export_data='';
		var queryParams=$(target).datagrid('options').queryParams;
		var evalStr = 'var Response = $'+'cm({';
		for(let key  in queryParams){
			var Param = key+':"'+queryParams[key]+'",'
			evalStr +=Param
	    };
		if (evalStr!='') evalStr=evalStr.substring(0,evalStr.length-1);
		evalStr +='},false);'	// 同步调用
		eval(evalStr);
		return toHtml(target,Response.rows,'','',columns,filename)
	}
	
    function toHtml(target, rows, footer, caption,columns,filename){
        rows = rows || getRows(target);
        rows = rows.concat(footer||getFooterRows(target));
        var dg = $(target);
		var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
		var clocount=0;
		for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
			if (columns.length>0){
				if ($.hisui.indexOfArray(columns,col.field)==-1) continue;
			}
			if (col.field=='_expander') continue;
			if (col.type=='btn') continue;
			if (col.hidden==true) continue;
			clocount++
        }
		//var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
		var queryParams=$(target).datagrid('options').queryParams;
		var aDateFrom,aDateTo='';
		for(let key  in queryParams){
			if (key=='aDateFrom'){
				aDateFrom = queryParams[key];
			}
			if (key=='aDateTo'){
				aDateTo = queryParams[key];
			}
	    };
		if (aDateFrom!=''){
			var qdate = aDateFrom+'~'+aDateTo;
		}else{
			var qdate = '';
		}
		var tablestyle='<table border="1" rull="all" style="border-collapse:collapse">';
		var theadstyle=
			'<thead>'+
			'<tr style="height:40px">'+
				'<td colspan="'+clocount+ '" style="font-weight:blod;font-size:30;vertical-align:middle;padding:0 4px;width:96px;;text-align:center">'+filename.split('.')[0]+'</td>'+
			'</tr>'+
			'<tr style="height:32px">'+
				'<td colspan="'+clocount+'" style="vertical-align:middle;padding:0 4px;width:96px;;text-align:left">查询日期：'+qdate+
				'</td>'+
			'</tr>'+
			'<thead>';
		var data = [tablestyle+theadstyle];
        var trStyle = 'height:32px';
        var tdStyle0 = 'vertical-align:middle;padding:0 4px';
        if (caption){
            data.push('<caption>'+caption+'</caption>');
        }
        data.push('<tr style="'+trStyle+'">');
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
			if (columns.length>0){
				if ($.hisui.indexOfArray(columns,col.field)==-1) continue;
			}
			if (col.field=='_expander') continue;
			if (col.type=='btn') continue;
			if (col.hidden==true) continue;
            var tdStyle = tdStyle0 + ';width:'+col.boxWidth+'px;';
            tdStyle += ';text-align:'+(col.halign||col.align||'');
            data.push('<td style="'+tdStyle+'">'+col.title+'</td>');
        }
        data.push('</tr>');
        var aPrintNum = 0;
        $.map(rows, function(row){
            data.push('<tr style="'+trStyle+'">');
            for(var i=0; i<fields.length; i++){
                var field = fields[i];
                var col   = dg.datagrid('getColumnOption', field);
				if (columns.length>0){
					if ($.hisui.indexOfArray(columns,col.field)==-1) continue;
				}
				if (col.field=='_expander') continue;
				if (col.type=='btn') continue;
				if (col.hidden==true) continue;
                var value = row[field];
                if (value == undefined){
                    value = '';
                }
                var tdStyle = tdStyle0;
                tdStyle += ';white-space: nowrap;text-align:'+(col.align||'');
                data.push(
                    '<td style="'+tdStyle+'">'+value+'&nbsp</td>'
                );
            }
            aPrintNum = aPrintNum+1
            
            data.push('</tr>');
        });
        
        data.push(
            '<td colspan="'+clocount+'" style="vertical-align:middle;padding:0 4px;width:96px;height:32px;text-align:left">总数：'+aPrintNum+'&nbsp</td>'
        );
        
        data.push('</table>');
        return data.join('');
    }

    function toArray(target, rows){
        rows = rows || getRows(target);
        var dg = $(target);
        var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var data = [];
        var r = [];
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
            r.push(col.title);
        }
        data.push(r);
        $.map(rows, function(row){
            var r = [];
            for(var i=0; i<fields.length; i++){
                r.push(row[fields[i]]);
            }
            data.push(r);
        });
        return data;
    }

    function print(target, param){
        var title = null;
        var rows = null;
        var footer = null;
        var caption = null;
		var model  = null;
		var columns = [];
        if (typeof param == 'string'){
            title = param;
        } else {
			columns = param['columns']||[];	// 打印列
			model = param['model'];
            title = param['title'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
        }
        var newWindow = window.open('', '', 'width=800, height=500');
        var document = newWindow.document.open();
		
		if (model==1){
			var content = 
            '<!doctype html>' +
            '<html>' +
            '<head>' +
            '<meta charset="utf-8">' +
            //'<title>'+title+'</title>' +
            '</head>' +
			'<body>' + serverDataToHtml(target,columns,title) + '</body>' +
            '</html>';
		}else{
			 var content = 
            '<!doctype html>' +
            '<html>' +
            '<head>' +
            '<meta charset="utf-8">' +
            //'<title>'+title+'</title>' +
            '</head>' +
            '<body>' + toHtml(target, rows, footer, caption,columns,title) + '</body>' +
            '</html>';
		}
        document.write(content);
        document.close();
		//if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
		if ( navigator.userAgent.indexOf('MSIE')>=0 || navigator.userAgent.indexOf('Trident')>=0){
			try{ 
				var hkey_root,hkey_path,hkey_key; 
				hkey_root="HKEY_CURRENT_USER"; hkey_path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
				var RegWsh = new ActiveXObject("WScript.Shell");

				//设置页眉/脚的字体样式
				hkey_key="font";
				RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"font-size: 12px; font-family: 黑体; line-height: 24px");

				//设置页眉
				hkey_key="header";
				RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"");

				//设置页脚
				hkey_key="footer"; 
				RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"&b第 &p 页/共 &P 页"); 

				//设置页边距(0.6 要乘以 2.5为实际打印的尺寸)
				hkey_key="margin_bottom";   
				RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"0.6");

				hkey_key="margin_left";        RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"0.6");

				hkey_key="margin_right";          RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"0.6"); 

				hkey_key="margin_top";          RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"0.6");
				newWindow.print();
			}catch(e){
				alert(e.name+"  "+e.message);
			} 
		}else{
			newWindow.print();
		}  
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
            type: ''
        });
    }

    function toExcel(target, param){
        var filename = null;
        var rows = null;
        var footer = null;
        var caption = null;
		var model  = null;
		var columns = [];
        var worksheet = 'Worksheet';
        if (typeof param == 'string'){
            filename = param;
        } else {
			columns	 = param['columns']||[];
			model	 = param['model'];
            filename = param['filename'];
            rows = param['rows'];
            footer = param['footer'];
            caption = param['caption'];
            worksheet = param['worksheet'] || 'Worksheet';
        }
        var dg = $(target);
        var uri = 'data:application/vnd.ms-excel;base64,'
        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
		if (model==1){
			var table = serverDataToHtml(target,columns,filename);
		}else{
			var table = toHtml(target, rows, footer, caption,columns,filename);
		}
        var ctx = { worksheet: worksheet, table: table };
        var data = base64(format(template, ctx));
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
	
	function Export(target, param){
		var dg = $(target);
		var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var filename = null;
		var extension = null;
		var arrviewFields = [];	
		var arrviewTitles = [];		// 第一行头
        if (typeof param == 'string'){
            filename = param;
        } else {
			filename = param['filename'];
			extension = param['extension'];
			arrviewFields	 = param['viewFields']||[];
			arrviewTitles	 = param['viewTitles']||[];
        }
		
		var arguments = '';
		var queryParams=$(target).datagrid('options').queryParams;
		var count=1
		for(let key  in queryParams){
			if ((key=='ClassName')||(key=='QueryName')||(key=='rows')) continue;
			
			var tArgument	= queryParams[key];
			if (typeof(tArgument)=='undefined') tArgument='';
			if (count==1) {
				arguments = tArgument;
			}else{
				arguments = arguments+'^'+tArgument;
			}
			count++;
			/*
			if (arguments=='')
			{
				arguments = tArgument;
			}else{
				arguments = arguments+'^'+tArgument;
			}*/
	    };
	    var tarrviewTitles = [];
		var tarrviewFields = [];
		for(var i=0; i<fields.length; i++){
			var col = dg.datagrid('getColumnOption', fields[i]);
			if (arrviewFields.length>0){
				if ($.hisui.indexOfArray(arrviewFields,col.field)==-1) continue;
			}
			if (arrviewTitles.length>0){
				if ($.hisui.indexOfArray(arrviewTitles,col.title)==-1) continue;
			}

			if (col.field=='_expander') continue;
			if (col.type=='btn') continue;
			if (col.hidden==true) continue;
			tarrviewTitles.push(col.title)
			tarrviewFields.push(col.field)
		}
		arrviewTitles = tarrviewTitles;
		arrviewFields = tarrviewFields;
		var viewFields = '';
		for (i=0;i<arrviewFields.length ;i++ ){
			if (viewFields==''){
				viewFields = arrviewFields[i];
			}else{
				viewFields = viewFields+'^'+arrviewFields[i];
			}
		}
		var viewTitles = '';
		for (i=0;i<arrviewTitles.length ;i++ ){
			if (viewTitles==''){
				viewTitles = arrviewTitles[i];
			}else{
				viewTitles = viewTitles+'^'+arrviewTitles[i];
			}
		}
		var queryParams=$(target).datagrid('options').queryParams;
		var className = queryParams.ClassName;
		var queryName = queryParams.QueryName;
		
		$m({
			ClassName:"MA.IPMR.SSService.ExcelSrv",
			MethodName:"ExportGridFromServer",
			aFileName:filename,
			aExtension:extension,
			aClassName:className,
			aQueryName:queryName,
			aArguments:arguments,
			aViewFields:viewFields,
			aViewTitles:viewTitles
		},function(txtData){
			//window.location.href=txtData;
			var url = txtData;
			var form=$("<form id='download' class='hidden' method='post'></form>");
			form.attr("style","display:none");
			form.attr("target","");
			form.attr("method","post"); 
			form.attr("timeout",10000000); 
			form.attr("action",url);
			$("body").append(form);
			form.submit();//表单提交
		});
    }

    function exportByJsxlsx(target, param){
		var dg = $(target);
		var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var filename = null;
		var extension = null;
		var arrviewFields = [];	
		var arrviewTitles = [];		// 第一行头
        if (typeof param == 'string'){
            filename = param;
        } else {
			filename = param['filename'];
			extension = param['extension'];
			arrviewFields	 = param['viewFields']||[];
			arrviewTitles	 = param['viewTitles']||[];
        }
		
		var arguments = '';
		var queryParams=$(target).datagrid('options').queryParams;
		for(let key  in queryParams){
			if ((key=='ClassName')||(key=='QueryName')||(key=='rows')) continue;
			
			var tArgument	= queryParams[key];
			if (typeof(tArgument)=='undefined') tArgument='';
			if (arguments=='')
			{
				arguments = tArgument;
			}else{
				arguments = arguments+'^'+tArgument;
			}
	    };
	    var tarrviewTitles = [];
		var tarrviewFields = [];
		for(var i=0; i<fields.length; i++){
			var col = dg.datagrid('getColumnOption', fields[i]);
			if (arrviewFields.length>0){
				if ($.hisui.indexOfArray(arrviewFields,col.field)==-1) continue;
			}
			if (arrviewTitles.length>0){
				if ($.hisui.indexOfArray(arrviewTitles,col.title)==-1) continue;
			}

			if (col.field=='_expander') continue;
			if (col.type=='btn') continue;
			if (col.hidden==true) continue;
			tarrviewTitles.push(col.title)
			tarrviewFields.push(col.field)
		}
		arrviewTitles = tarrviewTitles;
		arrviewFields = tarrviewFields;
		var viewFields = '';
		for (i=0;i<arrviewFields.length ;i++ ){
			if (viewFields==''){
				viewFields = arrviewFields[i];
			}else{
				viewFields = viewFields+'^'+arrviewFields[i];
			}
		}
		var viewTitles = '';
		for (i=0;i<arrviewTitles.length ;i++ ){
			if (viewTitles==''){
				viewTitles = arrviewTitles[i];
			}else{
				viewTitles = viewTitles+'^'+arrviewTitles[i];
			}
		}
		var queryParams=$(target).datagrid('options').queryParams;
		var className = queryParams.ClassName;
		var queryName = queryParams.QueryName;
		$m({
			ClassName:"MA.IPMR.SSService.ExcelSrv",
			MethodName:"exportByJsxlsx",
			aClassName:className,
			aQueryName:queryName,
			aArguments:arguments,
			aFields:viewFields,
			aTitles:viewTitles
		},function(txtData){
			var data = JSON.parse(txtData)
			var sheet = XLSX.utils.json_to_sheet(data.rows);
			openDownloadDialog(sheet2blob(sheet), filename+'.'+extension);
		});
    }
	 /**
	 * 通用的打开下载对话框方法，没有测试过具体兼容性
	 * @param url 下载地址，也可以是一个blob对象，必选
	 * @param saveName 保存文件名，可选
	 */
	function openDownloadDialog(url, saveName)
	{
		// for ie 10 and later
	    if (window.navigator.msSaveBlob) {
	        try {
	            window.navigator.msSaveBlob(url, saveName);
	        }
	        catch (e) {
	            console.log(e);
	        }
	    }else{
			if(typeof url == 'object' && url instanceof Blob)
			{
			  url = URL.createObjectURL(url); // 创建blob地址
			}

			var aLink = document.createElement('a');
			aLink.href = url;
			aLink.download = saveName || ''; // HTML5新增的属性，指定保存文件名，可以不要后缀，注意，file:///模式下不会生效
			var event;

			if(window.MouseEvent) event = new MouseEvent('click');
			else
			{
			  event = document.createEvent('MouseEvents');
			  event.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
			}
			aLink.dispatchEvent(event);
		}
	}

	// csv转sheet对象
	function csv2sheet(csv) {
	   var sheet = {}; // 将要生成的sheet
	   csv = csv.split('\n');
	   csv.forEach(function(row, i) {
	      row = row.split(',');
	      if(i == 0) sheet['!ref'] = 'A1:'+String.fromCharCode(65+row.length-1)+(csv.length-1);
	      row.forEach(function(col, j) {
	         sheet[String.fromCharCode(65+j)+(i+1)] = {v: col};
	      });
	   });
	   return sheet;
	}
	 
	// 将一个sheet转成最终的excel文件的blob对象，然后利用URL.createObjectURL下载
	function sheet2blob(sheet, sheetName) {
	   sheetName = sheetName || 'sheet1';
	   var workbook = {
	      SheetNames: [sheetName],
	      Sheets: {}
	   };
	   workbook.Sheets[sheetName] = sheet;
	   // 生成excel的配置项
	   var wopts = {
	      bookType: 'xlsx', // 要生成的文件类型
	      bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
	      type: 'binary'
	   };
	   var wbout = XLSX.write(workbook, wopts);
	   var blob = new Blob([s2ab(wbout)], {type:"application/octet-stream"});
	   // 字符串转ArrayBuffer
	   function s2ab(s) {
	      var buf = new ArrayBuffer(s.length);
	      var view = new Uint8Array(buf);
	      for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
	      return buf;
	   }
	   return blob;
	}

    $.extend($.fn.datagrid.methods, {
        toHtml: function(jq, rows){
            return toHtml(jq[0], rows);
        },
        toArray: function(jq, rows){
            return toArray(jq[0], rows);
        },
        toExcel: function(jq, param){
            return jq.each(function(){
                toExcel(this, param);
            });
        },
        print: function(jq, param){
            return jq.each(function(){
                print(this, param);
            });
        },
		Export: function(jq, param){
            return jq.each(function(){
                Export(this, param);
            });
        },
        exportByJsxlsx: function(jq, rows){
	         return exportByJsxlsx(jq[0], rows);
	    }
    });
})(jQuery);