
Ext.namespace("Ext.dhcc");

Ext.dhcc.DataToExcelTool = function(){
	this.ExcelApp=Ext.dhcc.ExcelApp;
	this.ExprotGrid=ExprotGrid;

	// ********************************************** //
	// Add By LiKai 2012-10-18
	// Ժ�б����ѯ���ӡ�ɾ������ֶ��б�
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
	var objSrc=new ActiveXObject("Shell.Application").BrowseForFolder(0,"��ѡ��·��",0,"");
	if (objSrc!=null){
		//update by zf 2012-12-06
		//FilePath=objSrc.Items().Item().Path;
		if (objSrc.Self.IsFileSystem) {
			FilePath=objSrc.Self.Path;
		} else {
			alert('��ѡ����ȷ·��!');
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

//�����������ܣ�����ExtGrid���ݵ�Excel
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
// Ժ�б����ѯ���ӡ�ɾ������ֶ��б�
function ExprotGridNew(grid,argFileName) {

	var objExcelTool=Ext.dhcc.DataToExcelTool;
	objExcelTool.ExcelApp.InitApp();
	//objExcelTool.ExcelApp.SetVisible(true);      //remove by likai 2012-10-18
	
	//������ͷ
  	objExcelTool.ExcelApp.WriteData(1,1,"����");
  	objExcelTool.ExcelApp.xlSheet.Columns(1).ColumnWidth=20;
  	objExcelTool.ExcelApp.WriteData(1,2,"�ǼǺ�");
    objExcelTool.ExcelApp.xlSheet.Columns(2).ColumnWidth=20;
  	objExcelTool.ExcelApp.WriteData(1,3,"������");
    objExcelTool.ExcelApp.xlSheet.Columns(3).ColumnWidth=15;
  	objExcelTool.ExcelApp.WriteData(1,4,"����");
    objExcelTool.ExcelApp.xlSheet.Columns(4).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,5,"�Ա�");
    objExcelTool.ExcelApp.xlSheet.Columns(5).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,6,"����");
    objExcelTool.ExcelApp.xlSheet.Columns(6).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,7,"����");
    objExcelTool.ExcelApp.xlSheet.Columns(7).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,8,"����");
    objExcelTool.ExcelApp.xlSheet.Columns(8).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,9,"��Ժ����");
    objExcelTool.ExcelApp.xlSheet.Columns(9).ColumnWidth=25;
	objExcelTool.ExcelApp.WriteData(1,10,"��Ժ���");
    objExcelTool.ExcelApp.xlSheet.Columns(10).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,11,"ҽԺ��Ⱦ����");
    objExcelTool.ExcelApp.xlSheet.Columns(11).ColumnWidth=25;
	objExcelTool.ExcelApp.WriteData(1,12,"��Ⱦ��λ");
    objExcelTool.ExcelApp.xlSheet.Columns(12).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,13,"�����Բ���");
    objExcelTool.ExcelApp.xlSheet.Columns(13).ColumnWidth=40;
	objExcelTool.ExcelApp.WriteData(1,14,"�Ƿ�����");
    objExcelTool.ExcelApp.xlSheet.Columns(14).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,15,"�п�����");
    objExcelTool.ExcelApp.xlSheet.Columns(15).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,16,"�Ƿ�ԭѧ����");
    objExcelTool.ExcelApp.xlSheet.Columns(16).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,17,"�걾");
    objExcelTool.ExcelApp.xlSheet.Columns(17).ColumnWidth=20;
	objExcelTool.ExcelApp.WriteData(1,18,"��ԭ������");
    objExcelTool.ExcelApp.xlSheet.Columns(18).ColumnWidth=40;
	objExcelTool.ExcelApp.WriteData(1,19,"��������");
    objExcelTool.ExcelApp.xlSheet.Columns(19).ColumnWidth=15;
	objExcelTool.ExcelApp.WriteData(1,20,"������");
    objExcelTool.ExcelApp.xlSheet.Columns(20).ColumnWidth=15;

  	objExcelTool.ExcelApp.SetRangeHorizontalAlignment(1,1,1,2,-4108);  //xlRight -4152   xlLeft -4131    xlCenter -4108
  
	//�����б�����
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

//������ӡ���ܣ���ӡExtGrid����
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
			            this.ExcelApp.WriteData(row+rowIndex+1,col+colIndex,'ѡ��');
			        }else if (cfg.id=='numberer'){
			        	this.ExcelApp.WriteData(row+rowIndex+1,col+colIndex,'���');
			        }else{
			        	cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); //Modified By LiYang 2011-06-03 ��ӡ����HTML��ǩ
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
    var n = 0;
    for(var i=0;i<cm.config.length;++i)
    {
        cfg = cm.config[i];
        if(cfg.id == 'checker')
        {
            this.ExcelApp.WriteData(row,col+i,'ѡ��');
        }else if (cfg.id=='numberer'){
        	this.ExcelApp.WriteData(row,col+i,'���');
        }else if (cfg.id=='expander') //Add By LiYang 2011-12-08 ����ؽ������
        {
        	this.ExcelApp.WriteData(row,col+i,'��ؽ����ϸ');
        }else{
        	cfg.header = ReplaceText(cfg.header, "<BR/>", "\n"); //Modified By LiYang 2011-06-03 ��ӡ����HTML��ǩ
        	cfg.header = ReplaceText(cfg.header, "<br/>", "\n");
        	cfg.header = ReplaceText(cfg.header, "<br>", "\n");
        	if ((typeof(IsSecret)!="undefined")&&(IsSecret!=1))     //�����ܣ�csp�ļ��ж��壩
        	{
        		if ((cfg.id=="Secret1")||(cfg.id=="Secret2"))  //�������ܼ����͡����˼������в����
        		{
	        		n++;
	        		continue; 
        		}
        	}
        	this.ExcelApp.WriteData(row,col+i-n,cfg.header);
        }
        var colwidth=cfg.width;
        if(cfg.id != 'expander')
        	this.ExcelApp.xlSheet.Columns(col+i-n).ColumnWidth=colwidth/5;
        else
        	this.ExcelApp.xlSheet.Columns(col+i-n).ColumnWidth = 50;
        	
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
	    var n = 0;
    	if (isChecked){  //ͨ��ѡ���ж��Ƿ񵼳�
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
	            if ((typeof(IsSecret)!="undefined")&&(IsSecret!=1))     //�����ܣ�csp�ļ��ж��壩
        		{
        			if ((cfg.id=="Secret1")||(cfg.id=="Secret2"))  //�������ܼ����͡����˼������в����
        			{
	        			n++;
	        			continue;
        			}
        			
        		}
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
	                //Modified By LiYang 2013-03-13 FixBug:54 ��Ⱦ������-��Ⱦ�������ѯ-���鵼���ļ�����ʾ��ѡ����
	                if(!Ext.isBoolean(val)) {
	                	this.ExcelApp.WriteData(row, col + i-n, val);
	                }
	                else
	                	this.ExcelApp.WriteData(row, col + i, (val ? "��" : ""));
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