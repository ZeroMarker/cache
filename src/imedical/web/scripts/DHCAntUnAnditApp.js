 document.body.onload=BodyLoadHandler;
function BodyLoadHandler(){ 
	var obj=document.getElementById('Export');
	if(obj){  obj.onclick=ExportClickHandler;}
}
function ExportClickHandler(){
	try{
		var pathObj=document.getElementById('getpath');
		if (pathObj) {var encmeth=pathObj.value} else {var encmeth=''};
		var path=cspRunServerMethod(encmeth)
		var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j 
	    var Template
	    var Template=path+"DHCAntUnAnditApp.xls"
	    	
	    xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet ; 
		
		var tid=document.getElementById("Tidz1").value
		var Obj=document.getElementById('GetDetail24hNum')
		if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
		var AntUseInfoNum=cspRunServerMethod(encmeth,tid);
		if (AntUseInfoNum==""){
			alert("û�����ݿ��Ե���");
			return;
			}
		//xlsheet.Cells(4,3)="��ʼ����"
		//var obj=document.getElementById('StDate'); //��ѯ��ʼ����
		//if (obj){xlsheet.Cells(4,4)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		//var obj=document.getElementById('EndDate');  //��ѯ��������
		//xlsheet.Cells(4,7)="��������"
		//if (obj){xlsheet.Cells(4,8)=obj.value.split("/")[2]+"-"+obj.value.split("/")[1]+"-"+obj.value.split("/")[0];}
		
		xlsheet.cells(2,1)="ҽ����"
		xlsheet.cells(2,2)="���Ʒ���"
		xlsheet.cells(2,3)="����ҽ��"
		xlsheet.cells(2,4)="�������"
		xlsheet.cells(2,5)="����ʱ��"
		xlsheet.cells(2,6)="����״̬"
		xlsheet.cells(2,7)="�ǼǺ�"
		xlsheet.cells(2,8)="��������"
		xlsheet.cells(2,9)="�÷�"
		xlsheet.cells(2,10)="Ƶ��"
		xlsheet.cells(2,11)="�Ƴ�"
		xlsheet.cells(2,12)="ʹ��Ŀ��"
		xlsheet.cells(2,13)="�Ƿ����"
		xlsheet.cells(2,14)="�Ƿ��ѳ�24Сʱ"
		
		for (var i=1;i<=AntUseInfoNum;i++){
			var Obj=document.getElementById('GetDetail24h')
			if(Obj){ var encmeth=Obj.value} else{ var encmeth=''};
			var DataDetailArr=cspRunServerMethod(encmeth,tid,i);
			
			var Detail=DataDetailArr.split("^");
			var len=Detail.length;
			for(var j=0;j<len;j++){
				xlsheet.cells(2+i,j+1)=Detail[j];
				}
		}
		
		var ExTimeOBJ=new Date();
		//var ExTime=ExTimeOBJ.toLocaleString();
		//var ExTime=ExTime.replace(/\s/ig,'');
		
		var month=ExTimeOBJ.getMonth()+1;       //��ȡ��ǰ�·�(0-11,0����1��)
		var date=ExTimeOBJ.getDate();        //��ȡ��ǰ��(1-31)
		var hour=ExTimeOBJ.getHours();       //��ȡ��ǰСʱ��(0-23)
		var minute=ExTimeOBJ.getMinutes();     //��ȡ��ǰ������(0-59)
		var sec=ExTimeOBJ.getSeconds();     //��ȡ��ǰ����(0-59)
		var ExTime=month+"��"+date+"��"+hour+"ʱ"+minute+"��"+sec+"��"
		//xlApp.Visible=true;
		//xlsheet.PrintPreview();
		var Expath="C:\\����ҩ��ʹ���������"+ExTime+".xls";
		xlsheet.SaveAs(Expath);      
		xlBook.Close(savechanges=true);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
		alert("�������!\n\n�ļ�λ�ã�"+Expath);
	}catch(e){
	     alert(e.message);
	     return;
	}
}