var processing = {
	ImportHISData: function (file) {
		var reader = new FileReader();
		reader.onload = function(e) {
			var data = e.target.result;
			var workbook = XLSX.read(data, {type: 'binary'});
			workbook.SheetNames.forEach(function (sheetName) {
				var data = XLSX.utils.sheet_to_json(workbook.Sheets[sheetName], { header: 1 });
				var operList = [];
				var errlog=""
				for (var i = 1; i < data.length; i++) {
					var ImportItem = data[i];
					if(ImportItem[0]==""){
						var count=i+1;
						errlog=InsertErrorLog(count,"表名称不能为空！！",errlog);
						continue;
					}
					var res=dhccl.runServerMethodNormal(ANCLS.BLL.OperQualificationManager,"ImportHisData",ImportItem);
					if(res.indexOf("S^")===0){
						
					}else{
						errlog=InsertErrorLog(i+1,res,errlog);
					}
				}
				if(errlog!=""){
					alert(errlog);
				}else{
					alert("导入完成")
				}
			})
		};
		reader.readAsBinaryString(file);
	},
	ExportHISData: function (className) {
		var aoa = []; // array of array
		var dataPara=dhccl.runServerMethod(ANCLS.BLL.OperQualificationManager,"ExportHISData",className);
		for (var fieldInd = 0; fieldInd < dataPara.length; fieldInd++) {
			var fieldArray = [];
			var columnField = dataPara[fieldInd];
			for(var key in columnField){
				fieldArray.push(columnField[key]);
			}
			aoa.push(fieldArray);
		}
		if (aoa.length > 0 && window.excelmgr) { 
			window.excelmgr.aoa2excel(aoa, "数据列表.xlsx");
		}
	},
	InsertErrorLog:function(count,errlog,result){
		if(result=="")  result="第"+count+"行导入失败,原因"+errlog
		else result=result+"\r\n"+"第"+count+"行导入失败,原因"+errlog
		return result
	}
}