
DHCMATools.DataToExcelTool = function(){
	this.ExcelApp=DHCMATools.ExcelApp;
	this.ExprotGrid=ExprotGrid;
	this.PrintGrid=PrintGrid;
	this.BuildHeader=BuildHeader;
	this.BuildBody=BuildBody;
	this.BuildSumRow=BuildSumRow;
	
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
function ExprotGrid(argGrid,argFileName)
{
	this.ExcelApp.InitApp();
	//this.ExcelApp.SetVisible(true);    //removed by wuqk 2011-11-15
	
	this.BuildHeader(argGrid,1,1);
    this.BuildBody(argGrid,2,1);
    
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
    var cm = grid.getColumnModel();
    var cfg = null;
    var n=-1;
    for(var i=0;i<cm.config.length;++i)
    {
        cfg = cm.config[i];
        if(!cfg.hidden){    //update by jiangpengpeng 2015-01-09 隐藏的列不打印
	        n++;
        	if(cfg.id == 'checker')
        	{
            	this.ExcelApp.WriteData(row,col+n,'选择');
        	}else if (cfg.id=='numberer'){
        		this.ExcelApp.WriteData(row,col+n,'序号');
        	}else{
        		cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); //Modified By LiYang 2011-06-03 打印出了HTML标签
        		cfg.header = ReplaceText(cfg.header, "<br/>", "\n");
        		cfg.header = ReplaceText(cfg.header, "<br>", "\n");
        		this.ExcelApp.WriteData(row,col+n,cfg.header);
        	}
        	var colwidth=cfg.width;
        	this.ExcelApp.xlSheet.Columns(col+n).ColumnWidth=colwidth/5;
    	}
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

function BuildBody(grid,row,col)
{
    var cm = grid.getColumnModel();
    var ds = grid.getStore();
	var rowNo=1;
    var cfg = null;
    ds.each(function(rec) {
   		var n=-1;
        for (var i = 0;i < cm.config.length;++i) {
            cfg = cm.config[i];
            if(!cfg.hidden){		//update by jiangpengpeng 2015-01-09 隐藏的列不打印
	            n++;
            	if (cfg.id == 'checker') {
                	this.ExcelApp.WriteData(row, col + n, ' ');
           		 }else if (cfg.id=='numberer'){
        			this.ExcelApp.WriteData(row, col + n, rowNo);
            	 }else{
                	var val = rec.get(cfg.dataIndex);
                	this.ExcelApp.WriteData(row, col + n, val);
            	 }
        	}
        }
        row++;
        rowNo++;
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

DataToExcelTool=DHCMATools.DataToExcelTool;