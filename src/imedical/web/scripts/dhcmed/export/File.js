/*
	本地文件读写
	by wuqk
	2013-01-17
*/
function File_SelectDir(){
	var FilePath="";
	var objSrc=new ActiveXObject("Shell.Application").BrowseForFolder(0,"请选择路径",0,"");
	if (objSrc!=null){
		if (objSrc.Self.IsFileSystem) {
			FilePath=objSrc.Self.Path;
		} else {
			alert('请选择正确路径!');
		}
	}
	return FilePath;
}

function File_writeFile(filename,filecontent){
	var fso, f, s ;
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.OpenTextFile(filename,8,true);
	f.WriteLine(filecontent);
	f.Close();
}

function File_readFile(filename){
	var fso, f, s ;
	fso = new ActiveXObject("Scripting.FileSystemObject");
	f = fso.OpenTextFile(filename,1,true);
	var s = f.ReadAll();
	f.Close();
	return s;
}

function File_getFiles(folderPath,fileType){
	var fso,folder,filesEnum,FileNameList="";
	fso=new ActiveXObject("Scripting.FileSystemObject");
    folder=fso.GetFolder(folderPath);
    filesEnum=new Enumerator(folder.files);
    while (!filesEnum.atEnd()){
        var  fileObj,fileName="",disName="";
        fileObj=filesEnum.item();
        fileName=fileObj.Name;
        if (FileNameList){
        	FileNameList=FileNameList+"/"+fileName;
       	}else{
       		FileNameList=fileName;
       	}
        filesEnum.moveNext();
    }
    return FileNameList;
}
function File_selectFile(folderPath,fileType,callback){
	var lsFileListStore = new Ext.data.Store({
		reader: new Ext.data.ArrayReader({id:0},
		[
			{name: 'ID', mapping: 0}
			,{name: 'FileName', mapping: 1}
		])
	});
	var tmpArray=new Array();
	var fso,folder,filesEnum,FileNameList="",i=0;
	fso=new ActiveXObject("Scripting.FileSystemObject");
    folder=fso.GetFolder(folderPath);
    filesEnum=new Enumerator(folder.files);
    while (!filesEnum.atEnd()){
        var  fileObj,fileName="",disName="";
        fileObj=filesEnum.item();
        fileName=fileObj.Name;
        extName=fileName.substr(fileName.lastIndexOf('.'),fileName.length);
        if (arrayContains(fileType,extName)){
	        tmpArray[i]=[i,fileName];
	        i++;
    	}
        filesEnum.moveNext();
    }
    if (i<1) return "";
    gridListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
    var gridList = new Ext.grid.GridPanel({
		buttonAlign : 'center'
		,store : lsFileListStore
		,loadMask : true
		,viewConfig: {forceFit: true}
		,columns: [ 
			//new Ext.grid.RowNumberer(),
			{ width: 400, dataIndex: 'FileName', sortable: true}  //header: 'FileName',
		],
		listeners : {
			'rowdblclick' : function(t,r,e){
				callback(t.getSelectionModel().getSelected().get("FileName"));
				t.findParentByType("window").hide();
			}
		}
		//,tbar:[obj.btnNew,obj.btnEdit]
	});
    //gridList.show();
    lsFileListStore.loadData(tmpArray);
    (new Ext.Window({
    		title : '请双击选择文件',
    		layout : 'fit',
    		modal : true,
    		plain : true,
    		width : 300,
    		height : 200,
    		items : [gridList]
    	})).show();
    
    return;
}


function arrayContains(array,obj) { 
	if (array==undefined) return true;
	var i = array.length; 
	if (i==0) return true;
	
	while (i--) { 
		if (array[i] === obj) { return true; } 
	} 
	return false; 
} 
