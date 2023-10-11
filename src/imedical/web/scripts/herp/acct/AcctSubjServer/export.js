/*
Ext.ux.clone = function (obj) {
    if (obj == null || typeof (obj) != 'object')
        return obj;
    if (Ext.isDate(obj))
        return obj.clone();
    var cloneArray = function (arr) {
        var len = arr.length;
        var out = [];
        if (len > 0) {
            for (var i = 0; i < len; ++i)
                out[i] = Ext.ux.clone(arr[i]);
        }
        return out;
    };
    var c = new obj.constructor();
    for (var prop in obj) {
        var p = obj[prop];
        if (Ext.isArray(p))
            c[prop] = cloneArray(p);
        else if (typeof p == 'object')
            c[prop] = Ext.ux.clone(p);
        else
            c[prop] = p;
    }
    return c;
};	



//Excel����
function ExportExcel(itemGrid, config) {
    if (itemGrid) {
        var tmpStore = itemGrid.getStore();
        var tmpExportContent = '';
	
        //���´����ҳgrid���ݵ��������⣬�ӷ������л�ȡ�������ݣ���Ҫ��������
        var tmpParam = Ext.ux.clone(tmpStore.lastOptions); //�˴���¡��ԭ��������Դ�Ĳ�����Ϣ

        if (tmpParam && tmpParam.params) {
            delete (tmpParam.params[tmpStore.paramNames.start]); //ɾ����ҳ����
            delete (tmpParam.params[tmpStore.paramNames.limit]);
             //tmpParam.params[tmpStore.paramNames.start]=0; 
            //tmpParam.params[tmpStore.paramNames.limit]=1000;
        }
        var tmpAllStore = new Ext.data.GroupingStore({//���¶���һ������Դ
            proxy: tmpStore.proxy,
            reader: tmpStore.reader
        });
        tmpAllStore.on('load', function (store) {
         
          var xls = new ActiveXObject("Excel.Application");
          var xlBook = xls.Workbooks.Add;      //����������
          var xlSheet = xlBook.Worksheets(1); //����������
          var cm = itemGrid.getColumnModel();
   		  var colCount = cm.getColumnCount();  
   		  //alert(colCount);
      	  var temp_obj = [];
    
  		 // ֻ����û�����ص���(isHidden()Ϊtrue��ʾ����,������Ϊ��ʾ)    
   		for (i = 2; i < colCount; i++) {
    		if (cm.isHidden(i) == true) {
    		} else {
     		temp_obj.push(i);   
     		}
   		}
		for (var i=4;i<=5;i++){
			for (var j=1;j<=temp_obj.length;j++){
				 xlSheet.Cells(i, j).Borders.Weight = 2;
				}
			}
		xls.Range("A1:L1").MergeCells = true;
		xlSheet.Cells(1, 1).Value ="�� Ŀ Ԥ �� �� ϸ ��";
		xlSheet.Cells(1, 1).Font.Name = "����"; 
		xlSheet.Cells(1, 1).Font.Bold = true; 
		xlSheet.Cells(1, 1).Font.Size = 15;
		xlSheet.Cells(1,1).HorizontalAlignment = 3; 
		xls.Range("A2:L2").MergeCells = true;
		xlSheet.Cells(2, 1).Value ="Ԥ����ȣ�"+yearField.getValue()+" ��";
		xlSheet.Cells(2,1).HorizontalAlignment = 3;
		xlSheet.Cells(3, 1).Value = "���Ƶ�λ��"
		xlSheet.Cells(3, 2).Value = "���Ҹ����ˣ�"
		xlSheet.Cells(3, 3).Value = "�����쵼��"
		xls.Range("C3:E3").MergeCells = true;
		xlSheet.Cells(3, 6).Value = "�ύʱ�䣺"
		xls.Range("F3:I3").MergeCells = true;
   	/*    xlSheet.Cells(4, 1).Value ="�ʽ����";
   	    xlSheet.Cells(4,1).HorizontalAlignment = 3; //���Ƶ�Ԫ�����
   	    xlSheet.Cells(4, 2).Value ="��Ŀ����";
   	    xlSheet.Cells(4,2).HorizontalAlignment = 3;	    
   	    xlSheet.Cells(4, 3).Value ="Ԥ��������";
   	    xlSheet.Cells(4,3).HorizontalAlignment = 3;    	   
   	    xlSheet.Cells(4, 4).Value ="Ԥ�����";
   	    xlSheet.Cells(4,4).HorizontalAlignment = 3;
   	    xlSheet.Cells(4, 5).Value ="Ԥ�㵥��";
   	    xlSheet.Cells(4,5).HorizontalAlignment = 3; 
   	    xlSheet.Cells(4, 6).Value ="Ԥ������";
   	    xlSheet.Cells(4,6).HorizontalAlignment = 3; 
	   xlSheet.Cells(4, 7).Value ="Ԥ����ռ��(%)";
   	    xlSheet.Cells(4,7).HorizontalAlignment = 3; 	
	   xlSheet.Cells(4, 8).Value ="Ԥ����";
   	    xlSheet.Cells(4,8).HorizontalAlignment = 3; 	
		   xlSheet.Cells(4, 9).Value ="�豸���Ʊ�ע";
   	    xlSheet.Cells(4,9).HorizontalAlignment = 3; 	
		   xlSheet.Cells(4, 10).Value ="����/����";
   	    xlSheet.Cells(4,10).HorizontalAlignment = 3; 	
			   xlSheet.Cells(4, 11).Value ="��Ա����-ԭ���豸";
   	    xlSheet.Cells(4,11).HorizontalAlignment = 3; 
		   xlSheet.Cells(4, 12).Value ="�շѱ�׼";
   	    xlSheet.Cells(4,12).HorizontalAlignment = 3; 	
	   xlSheet.Cells(4, 13).Value ="��Ч��Ԥ��";
   	    xlSheet.Cells(4,13).HorizontalAlignment = 3; 
	   xlSheet.Cells(4, 14).Value ="�Ĳķ�";
   	    xlSheet.Cells(4,14).HorizontalAlignment = 3; 		
		xlSheet.Cells(4, 15).Value ="��������";
   	    xlSheet.Cells(4,15).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 16).Value ="��ע";
   	    xlSheet.Cells(4,16).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 17).Value ="�Ƽ�Ʒ��1";
   	    xlSheet.Cells(4,17).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 18).Value ="����ͺ�1";
   	    xlSheet.Cells(4,18).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 19).Value ="�Ƽ�Ʒ��2";
   	    xlSheet.Cells(4,19).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 20).Value ="����ͺ�2";
   	    xlSheet.Cells(4,20).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 21).Value ="�Ƽ�Ʒ��3";
   	    xlSheet.Cells(4,21).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 22).Value ="����ͺ�3";
   	    xlSheet.Cells(4,22).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 23).Value ="���ο���";
   	    xlSheet.Cells(4,23).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 24).Value ="״̬";
   	    xlSheet.Cells(4,24).HorizontalAlignment = 3; */
		
   	/*	for (l = 2; l <= temp_obj.length+1; l++) {
    			xlSheet.Cells(4, l-1).Value = cm.getColumnHeader(temp_obj[l-2]); 
   			}
    			
   				var recordCount = store.getCount();
   				//alert("��¼������"+recordCount);
   				//alert('��������'+temp_obj.length);
   				var view = itemGrid.getView();
   				var tempstr=""
   				for (k = 1; k <= recordCount; k++) {
   					//alert('k-'+k);
   					//alert(view.getCell(k - 1, temp_obj[0]).innerText)
    				for (j = 1; j <= temp_obj.length; j++) {
     				// EXCEL���ݴӵڶ��п�ʼ,��row = k + 1
						
			    //tempstr=view.getCell(k - 1, temp_obj[0]).innerText;
				//alert(view.getCell(k - 1, temp_obj[j-1]).innerText)
				xlSheet.Cells(k + 4, j).Value = view.getCell(k - 1, temp_obj[j-1]).innerText;
     				xlSheet.Cells(k + 4, j).Borders.Weight = 2;//��ӱ߿�
     				}
				}
				var x=recordCount+5;
     			xls.Range("A"+x,"B"+x).MergeCells = true; 
     			xlSheet.Cells(x, 1).Value = "������ˣ�"
     			xls.Range("C"+x,"H"+x).MergeCells = true;
     			xlSheet.Cells(x, 3).Value = "��������ˣ�"
				xlSheet.Columns.AutoFit;//��Ԫ������Ӧ��С
   				xls.ActiveWindow.Zoom = 100;//�����С
   				xls.UserControl = true; // ����Ҫ,����ʡ��,��Ȼ������� ��˼��excel�����û�����
			
	     xls.DisplayAlerts = false; 
	     xls.save();//ѡ��·������
	     alert("�����ɹ�������");                    
  		 xls.Quit();  
 		 xls = null;
 		 //���̶�·������
 		 //xlSheet.SaveAs("C:\\Users\\Administrator.USER-20150630VQ\\Desktop\\Test.xls");
    	 xlBook.Close(savechanges=false);//�ر�
    	 xlSheet.Application.Quit();//��������
	//�˳�����excel��ʵ������
	xls.Application.Quit();
	//�ֶ����������ռ���
	CollectGarbage();	 
        });
        tmpAllStore.load(tmpParam); //��ȡ��������
   		
    }
}*/

/** ��ҳ��������Execl�������� **/
function ExportAllToExcel(gridPanel,name) {
	if(typeof gridPanel === 'string'){
		gridPanel = Ext.getCmp(gridPanel);
	}
	if (gridPanel) {
		var tmpStore = gridPanel.getStore();
		//���´����ҳgrid���ݵ��������⣬�ӷ������л�ȡ�������ݣ���Ҫ��������
		var tmpParam = tmpStore.lastOptions //�˴���¡��ԭ��������Դ�Ĳ�����Ϣ
		if (tmpParam && tmpParam.params) {
			tmpParam.params[tmpStore.paramNames.start]=0;
			tmpParam.params[tmpStore.paramNames.limit]=999999; //���÷�ҳ��Ϣ
		}else{
			Ext.Msg.show({title:'ע��',msg:'û����Ҫ���������ݣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('warning','û����Ҫ���������ݣ�');
			return false;
		}
		var tmpAllStore = new Ext.data.Store({	//���¶���һ������Դ
			proxy: tmpStore.proxy,
			reader: tmpStore.reader
		});
		tmpAllStore.on('load', function (store) {
			if(!name){
				//grid--title���button������⴦��
				var gridPanelTitle = Ext.isEmpty(gridPanel.title)? '' : gridPanel.title.split('&nbsp')[0];
				name = gridPanelTitle + new Date().format('Y-m-d-His');
			}
			if(document.all.ExportExcel == null || document.all.ExportExcel.object == null){
				StoreSaveAsExcel.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}else{
				StoreSaveAsExcelByOwc.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}
		});
		//��ȡ��������
		tmpAllStore.load({
			params : tmpParam.params,
			callback : function(r,options,success){
				if(!success){
					Ext.Msg.show({title:'ע��',msg:'���ݼ��ش���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					//Msg.info('error', '���ݼ��ش���!');
				}
			}
		});
	}
};

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}


function StoreSaveAsExcel(store,cm,name)
{
	if (store.getCount()==0)
	{
		Ext.Msg.show({title:'ע��',msg:'û����Ҫ���������ݣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		//Msg.info('warning','û����Ҫ���������ݣ�');
		return;
	}
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	fd.FileName=name
	// ��������MaxFileSize. �������
	fd.MaxFileSize = 32767;
	// ��ʾ�Ի���
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fd.Flags == 0 || fileName==''){
		return;
	}
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		//Msg.info("warning","���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�");
		Ext.Msg.show({title:'ע��',msg:'���밲װexcel��ͬʱ���������ִ��ActiveX�ؼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('�ļ�"'+fileDesc+'"�Ѿ����ڣ��Ƿ��滻ԭ���ļ���')==false){
			xlApp.Quit();
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var colCount=cm.getColumnCount();
	var temp_obj=[];	//�����Ҫ������columns
	var arr_obj=[];		//���ԭʼrecord����name
	
	var temp_obj=cm.getColumnsBy(function(c){
		return !(c.hidden || c.dataIndex=="" || c.IFExport===false);
	});
	
	//Excel��һ�д�ű���
	for (var n=0;n<temp_obj.length;n++){
		xlSheet.Cells(1,n+1).Value=temp_obj[n].header;
	}
	
	var recordCount=store.getCount();
	for (var k=0;k<recordCount;k++){
		var arrRecord=store.getAt(k);
		for (var j=0, colLen = temp_obj.length; j<colLen; j++){
			var colDataIndex=temp_obj[j].dataIndex;
			var colRenderer = temp_obj[j].renderer;
			var cellValue=arrRecord.get(colDataIndex);
			//column������, useRenderExport : false, ���ڵ���ʱ��ʹ�ø�column��renderer
			if(colRenderer.toString().replace(/\s/g,'')!="function(value){returnvalue;}"
			&& temp_obj[j].xtype!="checkcolumn" && temp_obj[j].useRenderExport!==false){
				var cellValue = temp_obj[j].renderer(cellValue,{},arrRecord,k,j,store);
			}
			cellValue = Ext.util.Format.stripTags(cellValue);
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				xlSheet.Cells(k+2,j+1).Value="\'"+cellValue;	//ȫ����ת�����ַ���
			}else{
				xlSheet.Cells(k+2,j+1).Value=cellValue;
			}
		}
	}
	
	try{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Ext.Msg.show({title:'ע��',msg:'���ʧ�ܣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('error','���ʧ�ܣ�') ;
		}else{
			Ext.Msg.show({title:'ע��',msg:'Excel�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('success', 'Excel�����ɹ�!');
		}
	}
	catch(e){
		Ext.Msg.show({title:'ע��',msg:'���ʧ�ܣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		//Msg.info('error','���ʧ�ܣ�') ;
	}

	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlSheet=null;
}
