//打印产时记录
function printLaborRec(callback){
	var LODOP = getLodop();
		LODOP.PRINT_INIT("产时记录");
		var json = $cm({
			ClassName: "Nur.NIS.Service.Labor.Handler",
			MethodName: "getRecPrintData",
			EpisodeID: EpisodeID
		},false)
		LODOP.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
		LODOP.ADD_PRINT_TABLE(100,0 , "100%", "100%", json.table);
		LODOP.ADD_PRINT_TEXT("10mm", "5mm", "200mm", 32, "产时记录\n");
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 16);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
		LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
		
		LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "姓名:");
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "20mm", 100, 25, json.patient.name);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "50mm", 100, 25, "床号:");
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "60mm", 74, 25, json.patient.bedCode);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "80mm", 100, 25, "登记号:");
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "93mm", 120, 25, json.patient.regNo);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "130mm", 100, 25, "住院号:");
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "143mm", 74, 25, json.patient.medicareNo);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "170mm", 100, 25, "科室:");
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		LODOP.ADD_PRINT_TEXT("20mm", "180mm", 90, 25, json.patient.ctLocDesc);
		LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
		LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
		
		
		var invPrtDevice="DHCC PDF Creator".toUpperCase();
		var invPrtDeviceIndex=-1;
		for(var i=0;i< LODOP.GET_PRINTER_COUNT(); i++){
			if (LODOP.GET_PRINTER_NAME(i).toUpperCase().indexOf(invPrtDevice)>-1){
				invPrtDeviceIndex=i
				break;
			}
		}
		LODOP.SET_PRINTER_INDEX(invPrtDeviceIndex);
		LODOP.PRINT();

		if (!!callback){
			callback()
		}
}

function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	var _options = {
		url : "Nur.Archive.cls",
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'className':className,
				'methodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler).error(successHandler);
	}
		
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return parseJsonString(ret.responseText)
}
function parseJsonString(jsonString) {
  try {
    var json = JSON.parse(jsonString);
    if (typeof json === 'object') {
      for (var key in json) {
        if (typeof json[key] === 'string') {
          json[key] = parseJsonString(json[key]);
        }
      }
    }
    return json;
  } catch (e) {
    return jsonString;
  }
}