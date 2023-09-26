
Ext.namespace("Ext.dhcc");

Ext.dhcc.DataToExcelTool = function(){
	this.ExcelApp=Ext.dhcc.ExcelApp;
	this.ExprotGrid=ExprotGrid;

	
	//this.ExprotGridNew=ExprotGridNew;
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
        }else if (cfg.id=='expander') 
        {
        	this.ExcelApp.WriteData(row,col+i,'监控结果明细');
        }else{
        	cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); 
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
    var objBuffer = document.createElement("<div style='visibility:hidden'/>");
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
		            }else if (cfg.id == "expander"){ 
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