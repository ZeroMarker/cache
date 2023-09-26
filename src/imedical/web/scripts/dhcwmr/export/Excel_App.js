
Ext.namespace("Ext.dhcc");

Ext.dhcc.DataToExcelTool = function(){
	this.ExcelApp=Ext.dhcc.ExcelApp;
	this.ExprotGrid=ExprotGrid;

	// ********************************************** //
	// Add By LiKai 2012-10-18
	// 院感报告查询增加、删除相关字段列表
	this.ExprotGridNew=ExprotGridNew;
	// ********************************************** //

	this.PrintGrid=PrintGrid;
	this.BuildHeader=BuildHeader;
	this.BuildBody=BuildBody;
	this.BuildSumRow=BuildSumRow;
	this.BuildBodyCols=BuildBodyCols;
	
	this.SelectDir=SelectDir;
	this.GetFiles=GetFiles;
	return this;
}();

function SelectDir(){
	var FilePath="";
	var objSrc=new ActiveXObject("Shell.Application").BrowseForFolder(0,"请选择路径",0,"");
	if (objSrc!=null){
		//update by zf 2012-12-06
		//FilePath=objSrc.Items().Item().Path;
		if (objSrc.Self.IsFileSystem) {
			FilePath=objSrc.Self.Path;
		} else {
			alert('请选择正确路径!');
		}
	}
	return FilePath;
}

function GetFiles(folderPath){
	var fso,folder,filesEnum,FileNameList="";
	fso=new ActiveXObject("Scripting.FileSystemObject");
    folder=fso.GetFolder(folderPath);
    filesEnum=new Enumerator(folder.files);
    while (!filesEnum.atEnd()){
        var  fileObj,fileName="",disName="";
        fileObj=filesEnum.item();
        fileName=fileObj.Name;
        //fileName=fileName.substr(0,fileName.lastIndexOf('.'));
        if (FileNameList){
        	FileNameList=FileNameList+"/"+fileName;
       	}else{
       		FileNameList=fileName;
       	}
        filesEnum.moveNext();
    }
    return FileNameList;
}

//基础导出功能，导出ExtGrid内容到Excel
function ExprotGrid(argGrid,argFileName,argIsChecked)
{
	this.ExcelApp.InitApp();
	//this.ExcelApp.SetVisible(true);      //remove by wuqk 2011-11-15
	
	this.BuildHeader(argGrid,1,1);
    this.BuildBody(argGrid,2,1,argIsChecked);
    
    this.ExcelApp.SaveBook(argFileName);
    this.ExcelApp.Close();
}

// ********************************************************************** //
// Add By LiKai 2012-10-18
// 院感报告查询增加、删除相关字段列表
function ExprotGridNew(grid,argFileName) {

	var objExcelTool=Ext.dhcc.DataToExcelTool;
	objExcelTool.ExcelApp.InitApp();
	//objExcelTool.ExcelApp.SetVisible(true);      //remove by likai 2012-10-18
	
	//导出表头
  	objExcelTool.ExcelApp.WriteData(1,1,"科室");
  	objExcelTool.ExcelApp.xlSheet.Columns(1).ColumnWidth=20;
  	objExcelTool.ExcelApp.WriteData(1,2,"登记号");
    objExcelTool.ExcelApp.xlSheet.Columns(2).ColumnWidth=20;
  	objExcelTool.ExcelApp.WriteData(1,3,"病案号");
    objExcelTool.ExcelApp.xlSheet.Columns(3).ColumnWidth=15;
  	objExcelTool.ExcelApp.WriteData(1,4,"姓名");
    objExcelTool.ExcelApp.xlSheet.Columns(4).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,5,"性别");
    objExcelTool.ExcelApp.xlSheet.Columns(5).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,6,"年龄");
    objExcelTool.ExcelApp.xlSheet.Columns(6).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,7,"病区");
    objExcelTool.ExcelApp.xlSheet.Columns(7).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,8,"床号");
    objExcelTool.ExcelApp.xlSheet.Columns(8).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,9,"入院日期");
    objExcelTool.ExcelApp.xlSheet.Columns(9).ColumnWidth=25;
	objExcelTool.ExcelApp.WriteData(1,10,"入院诊断");
    objExcelTool.ExcelApp.xlSheet.Columns(10).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,11,"医院感染日期");
    objExcelTool.ExcelApp.xlSheet.Columns(11).ColumnWidth=25;
	objExcelTool.ExcelApp.WriteData(1,12,"感染部位");
    objExcelTool.ExcelApp.xlSheet.Columns(12).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,13,"侵入性操作");
    objExcelTool.ExcelApp.xlSheet.Columns(13).ColumnWidth=40;
	objExcelTool.ExcelApp.WriteData(1,14,"是否手术");
    objExcelTool.ExcelApp.xlSheet.Columns(14).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,15,"切口类型");
    objExcelTool.ExcelApp.xlSheet.Columns(15).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,16,"是否病原学检验");
    objExcelTool.ExcelApp.xlSheet.Columns(16).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,17,"标本");
    objExcelTool.ExcelApp.xlSheet.Columns(17).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,18,"病原体名称");
    objExcelTool.ExcelApp.xlSheet.Columns(18).ColumnWidth=40;
	objExcelTool.ExcelApp.WriteData(1,19,"报告日期");
    objExcelTool.ExcelApp.xlSheet.Columns(19).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,20,"报告人");
    objExcelTool.ExcelApp.xlSheet.Columns(20).ColumnWidth=15;

  	objExcelTool.ExcelApp.SetRangeHorizontalAlignment(1,1,1,2,-4108);  //xlRight -4152   xlLeft -4131    xlCenter -4108
  
	//导出列表数据
	var rowIndex=1;
	var row=2;
	var ds =grid.getStore();
	ds.each(function(rec) {
		objExcelTool.ExcelApp.WriteData(row,1,rec.get('AdmLoc'));
		objExcelTool.ExcelApp.WriteData(row,2,rec.get('PapmiNo'));
		objExcelTool.ExcelApp.WriteData(row,3,rec.get('PatMrNo'));
		objExcelTool.ExcelApp.WriteData(row,4,rec.get('PatName'));
		objExcelTool.ExcelApp.WriteData(row,5,rec.get('PatSex'));
		objExcelTool.ExcelApp.WriteData(row,6,rec.get('PatAge'));
		objExcelTool.ExcelApp.WriteData(row,7,rec.get('AdmWard'));
		objExcelTool.ExcelApp.WriteData(row,8,rec.get('AdmBed'));
		objExcelTool.ExcelApp.WriteData(row,9,rec.get('AdmitDate'));
		objExcelTool.ExcelApp.WriteData(row,10,rec.get('DiagnosDesc'));
		objExcelTool.ExcelApp.WriteData(row,11,rec.get('InfDate'));
		objExcelTool.ExcelApp.WriteData(row,12,rec.get('InfPosIPDesc'));
		objExcelTool.ExcelApp.WriteData(row,13,rec.get('InvasiveOperDescreturn'));
		objExcelTool.ExcelApp.WriteData(row,14,rec.get('OprBooleanDesc'));
		objExcelTool.ExcelApp.WriteData(row,15,rec.get('CuteTypeDesc'));
		objExcelTool.ExcelApp.WriteData(row,16,rec.get('LabBooleanDesc'));
		objExcelTool.ExcelApp.WriteData(row,17,rec.get('SpecimenDesc'));
		objExcelTool.ExcelApp.WriteData(row,18,rec.get('PathogenyDescreturn'));
		objExcelTool.ExcelApp.WriteData(row,19,rec.get('DischDate'));
		objExcelTool.ExcelApp.WriteData(row,20,rec.get('ReportUserDesc'));
		rowIndex++;
		row++;
	});
	objExcelTool.ExcelApp.SaveBook(argFileName);
	objExcelTool.ExcelApp.Close();
}
// ********************************************************************** //

//基础打印功能，打印ExtGrid内容
function PrintGrid(argGrid,argIsPreview)
{
	this.ExcelApp.InitApp();
	this.ExcelApp.SetVisible(true);
	
	this.BuildHeader(argGrid,1,1);
    this.BuildBody(argGrid,2,1);
    
    this.ExcelApp.PrintOut(argIsPreview);
    this.ExcelApp.Close();
}

function BuildHeader(grid,row,col)
{
	/*
	var colIndex=0;
	var headerGroups=grid.plugins.config.rows;
	var cm = grid.getColumnModel();
    var cfg = null;
	for (var rowIndex=0;rowIndex<headerGroups.length;rowIndex++){
		var headerGroup=headerGroups[rowIndex];
		for (var groupIndex=0;groupIndex<headerGroup.length;groupIndex++){
			for (var colspanIndex=0;colspanIndex<headerGroup[groupIndex].colspan;colspanIndex++){
				this.ExcelApp.WriteData(row+rowIndex,col+colIndex,headerGroup[groupIndex].header);
				if (rowIndex==headerGroups.length-1){
					cfg = cm.config[colIndex];
			        if(cfg.id == 'checker')
			        {
			            this.ExcelApp.WriteData(row+rowIndex+1,col+colIndex,'选择');
			        }else if (cfg.id=='numberer'){
			        	this.ExcelApp.WriteData(row+rowIndex+1,col+colIndex,'序号');
			        }else{
			        	cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); //Modified By LiYang 2011-06-03 打印出了HTML标签
			        	cfg.header = ReplaceText(cfg.header, "<br/>", "\n");
			        	cfg.header = ReplaceText(cfg.header, "<br>", "\n");
			        	this.ExcelApp.WriteData(row+rowIndex+1,col+colIndex,cfg.header);
			        }
			        var colwidth=cfg.width;
			        this.ExcelApp.xlSheet.Columns(col+colIndex).ColumnWidth=colwidth/5;
				}
				colIndex++;
			}
			this.MergeCells(row+rowIndex,col+colIndex-headerGroup[groupIndex].colspan,row+rowIndex,col+colIndex);
		}
	}
	*/
    var cm = grid.getColumnModel();
    var cfg = null;
    for(var i=0;i<cm.config.length;++i)
    {
        cfg = cm.config[i];
        if(cfg.id == 'checker')
        {
            this.ExcelApp.WriteData(row,col+i,'选择');
        }else if (cfg.id=='numberer'){
        	this.ExcelApp.WriteData(row,col+i,'序号');
        }else if (cfg.id=='expander') //Add By LiYang 2011-12-08 将监控结果导出
        {
        	this.ExcelApp.WriteData(row,col+i,'监控结果明细');
        }else{
        	cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); //Modified By LiYang 2011-06-03 打印出了HTML标签
        	cfg.header = ReplaceText(cfg.header, "<br/>", "\n");
        	cfg.header = ReplaceText(cfg.header, "<br>", "\n");
        	this.ExcelApp.WriteData(row,col+i,cfg.header);
        }
        var colwidth=cfg.width;
        if(cfg.id != 'expander')
        	this.ExcelApp.xlSheet.Columns(col+i).ColumnWidth=colwidth/5;
        else
        	this.ExcelApp.xlSheet.Columns(col+i).ColumnWidth = 50;
        	
    }
}

function ReplaceText(str, find, repl)
 {
 	var strTmp = str;
 	while(strTmp.indexOf(find) >=0)
 	{
 		strTmp = strTmp.replace(find, repl);	
 	}	
 	return strTmp;
 }

function BuildBody(grid,row,col,isChecked)
{
    var cm = grid.getColumnModel();
    var ds = grid.getStore();
	var rowIndex=1;
    var cfg = null;
    //var objBuffer =document.createElement("<div style='visibility:hidden'/>");
    var objBuffer = document.createElement("div");
    objBuffer.style.visibility="hidden";
    document.body.appendChild(objBuffer);
    ds.each(function(rec) {
    	if (isChecked){  //通过选择判断是否导出
	    	if (rec.get('checked')){
		        for (var i = 0;i < cm.config.length;++i) {
		            cfg = cm.config[i];
		            if (cfg.id == 'checker') {
		                this.ExcelApp.WriteData(row, col + i, ' ');
		            }else if (cfg.id=='numberer'){
		            	//var IndNum = ReplaceText(rec.id, "ext-record-", '');
		        		this.ExcelApp.WriteData(row, col + i, rowIndex);
		            }else if (cfg.id == "expander"){ //Add By LiYang 2011-12-08
		            	var tmpData =  cfg.tpl.apply(rec.data);
		            	objBuffer.innerHTML = tmpData;
		            	this.ExcelApp.WriteData(row, col + i, objBuffer.innerText);
		            }else{
		                var val = rec.get(cfg.dataIndex);
		                this.ExcelApp.WriteData(row, col + i, val);
		            }
		        }
		        rowIndex++;
		        row++;
	    	}
    	}else{
    		for (var i = 0;i < cm.config.length;++i) {
	            cfg = cm.config[i];
	            if (cfg.id == 'checker') {
	                this.ExcelApp.WriteData(row, col + i, ' ');
	            }else if (cfg.id=='numberer'){
	            	//var IndNum = ReplaceText(rec.id, "ext-record-", '');
	        			this.ExcelApp.WriteData(row, col + i, rowIndex);
		          }else if (cfg.id == "expander"){ //Add By LiYang 2011-12-08
		          		//window.alert(cfg.bodyContent[rec.id]);
		            	var tmpData =  cfg.tpl.apply(rec.data);
		            	objBuffer.innerHTML = tmpData;
		            	this.ExcelApp.WriteData(row, col + i, objBuffer.innerText);      			
	            }else{
	                var val = rec.get(cfg.dataIndex);
	                //Modified By LiYang 2013-03-13 FixBug:54 传染病管理-传染病报告查询-建议导出文件中显示【选择】列
	                if(!Ext.isBoolean(val))
	                	this.ExcelApp.WriteData(row, col + i, val);
	                else
	                	this.ExcelApp.WriteData(row, col + i, (val ? "是" : ""));
	            }
	        }
	        rowIndex++;
	        row++;
    	}
    },this);
}

function BuildBodyCols(grid,row,col,fields)
{
    var cm = grid.getColumnModel();
    var ds = grid.getStore();
    var cfg = null;
    ds.each(function(rec) {
        for (var i = 0;i < fields.length;++i) {
    		var fieldName = fields[i];
    		if (fieldName!==""){
	            var val = rec.get(fieldName);
	            if(val){
	                this.ExcelApp.WriteData(row, col + i, val);
	            }
        	}
        }
        row++;
    },this);
}

function BuildSumRow(grid,row,col){
    var cm = grid.getColumnModel();
    var cfg = null;
    for (var i = 0;i < cm.config.length;++i) {
        cfg = cm.config[i];
        if(cfg.sumcaption){
            this.ExcelApp.WriteData(row,col+i,cfg.sumcaption);
        } 
        
        if(cfg.sumvalue){
            this.ExcelApp.WriteData(row,col+i,cfg.sumvalue);
        }
    }
}

DataToExcelTool=Ext.dhcc.DataToExcelTool;