function PrintPathAppSheet(tmrowid)
{ 
			//alert("1")
			 var xlApp,xlsheet,xlBook,Template
			 
		     var GetPrescPath=document.getElementById("GetRepPath");
			 if (GetPrescPath) {var encmeth=GetPrescPath.value} 
			 else {var encmeth=''};
			 if (encmeth!="") 
			 {
			 	var TemplatePath=cspRunServerMethod(encmeth);
			 }
			 
			//var TemplatePath="http://172.26.201.2/trakcarelive/trak/med/Templates/"
			Template=TemplatePath+"DHCPisAppSzbd.xls";
			
	    xlApp = new ActiveXObject("Excel.Application")
			xlBook = xlApp.Workbooks.Add(Template);
			xlsheet = xlBook.ActiveSheet;
      var duihao=String.fromCharCode(8730)        
      
      var bldprintfun=document.getElementById("bldprintfun").value;
      var pathInfos=cspRunServerMethod(bldprintfun,tmrowid)
			var pathInfo=pathInfos.split("## ")
			var tmInfo=pathInfo[0]
			var tsInfo=pathInfo[1]
			var twInfo=pathInfo[2]
			var ttInfo=pathInfo[3]
			var age=pathInfo[4]	
			if(tmInfo.split("^")[0]=="1")
		       {
				xlsheet.cells(2,7)=" ���б����걾������뵥";  
			}
      else
      {
	       xlsheet.cells(2,7)=" ���没��걾������뵥";  
      }
	    //����
	    xlsheet.cells(2,1)="*"+tmrowid+"*";  //�������뵥��
	    xlsheet.cells(3,4)=tmrowid;          //���뵥��
	    xlsheet.cells(3,10)=tmInfo.split("^")[32];           //�ǼǺ�
	    xlsheet.cells(3,17)=tmInfo.split("^")[31];     //ҽ����
	    
	    //������Ϣ                                                            
	    xlsheet.cells(5,3)=tmInfo.split("^")[13];             //��������
	    var sexInfo=tmInfo.split("^")[16]; 
	    xlsheet.cells(5,10)=sexInfo.split("~")[1];             //�����Ա�
	    xlsheet.cells(5,15)=age;             //��������
	    xlsheet.cells(5,21)=tmInfo.split("^")[17];			//��������
      xlsheet.cells(6,4)=tmInfo.split("^")[52];            //�绰����
      var leixing=tmInfo.split("^")[12]
	    xlsheet.cells(6,11)=leixing.split("~")[1];         //��������
	    var feibie=tmInfo.split("^")[15]
	    xlsheet.cells(6,17)=feibie.split("~")[1];	        //�ѱ�
	    xlsheet.cells(7,4)=tmInfo.split("^")[18];          //��סַ
	    
	    //������Ϣ
	    xlsheet.cells(9,4)=tmInfo.split("^")[27];           //�������
	    xlsheet.cells(9,14)=tmInfo.split("^")[29];          //����ҽ��
	    xlsheet.cells(9,21)=tmInfo.split("^")[25];         //��������
		
		var tclinicRecord=tmInfo.split("^")[19]
		var item=tclinicRecord.split(";")
		xlsheet.cells(10,4)=item[0].split("��������:")[1];        //��������
	    xlsheet.cells(10,21)=item[1].split("������:")[1];      //������
		xlsheet.cells(11,21)=item[5].split("������:")[1]      //������
		var ssks=item[2].split("������ʼ����:")[1]
	    var osd=ssks.split(" ")[0]
	    if(osd!="")
      	{
	  		var item1=osd.split("/")
      		osd=item1[2]+"-"+item1[1]+"-"+item1[0];   //��������
      	}
	    xlsheet.cells(11,5)=osd+" "+ssks.split(" ")[1];      //��ʼ����
		xlsheet.cells(11,15)=item[3].split("Ԥ���ͼ�ʱ��:")[1];      //Ԥ���ͼ�����
		
      xlsheet.cells(13,1)=tsInfo                                                //�걾��Ϣ
	    xlsheet.cells(15,1)=item[4].split("�ٴ�����:")[1];        //�ٴ�����
	    xlsheet.cells(17,1)=tmInfo.split("^")[20];      //��������
//alert(item[6].split("�����������:")[1])
	   xlsheet.cells(19,1)=item[6].split("�����������:")[1];      //��������
	    xlsheet.cells(21,1)=tmInfo.split("^")[23];      //�ٴ����
	    
	    //������Ϣ
      xlsheet.cells(25,4)=ttInfo.split("^")[1];   //������λ
      xlsheet.cells(25,12)=ttInfo.split("^")[2];    //������С

      xlsheet.cells(25,20)=ttInfo.split("^")[0];    //��������
     
      if(ttInfo.split("^")[3]=="Y")   //����ת��)
          xlsheet.cells(26,4)=duihao
      xlsheet.cells(26,8)=ttInfo.split("^")[4]   //ת�Ʋ�λ
      if(ttInfo.split("^")[5]=="Y")   //�������
          xlsheet.cells(26,17)=duihao
      if(ttInfo.split("^")[6]=="Y")   //������
          xlsheet.cells(26,22)=duihao
      xlsheet.cells(27,3)=ttInfo.split("^")[7];             //��ע
      
      //������Ϣ
      xlsheet.cells(29,4)=twInfo.split("^")[0];   //ĩ���¾�
      
	    if(twInfo.split("^")[1]=="Y")   //�Ƿ����
	       xlsheet.cells(29,12)=duihao
	    xlsheet.cells(29,17)=twInfo.split("^")[2];   //̥
	    xlsheet.cells(29,20)=twInfo.split("^")[3];    //��
	    
	    xlsheet.PrintOut 
    	xlBook.Close (savechanges=false);
    	xlBook=null
    	xlApp.Quit();
    	xlApp=null;
    	xlsheet=null 
    	//window.setInterval("Cleanup();",1); 
}