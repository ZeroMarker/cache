
   /*
   LiangQiang 2014-08-08
   ���Ƶ���Div����,Ĭ���Ǵ�Ʒ��Ŀ�б�
   */
   var CreatMyDiv=function (input,tarobj,mydivid,mydivw,mydivh,mytblid,mycols,mydgs,mydgid,mydesc,fn)
	{
		this.input=input;��//���
		this.tarobj=tarobj; //Ŀ��Դ
		this.mydivid=mydivid; //
		this.mydivw=mydivw;
		this.mydivh=mydivh;
		this.mytblid=mytblid;
		this.mycols=mycols;
		this.mydgs=mydgs;
		this.fn=fn;
		


	}

	CreatMyDiv.prototype={ 

		init:function(){
			  
			  var input=this.input;
			  var tarobj=this.tarobj;
			  var mydivid=this.mydivid;
			  var mydivw=this.mydivw;
			  var mydivh=this.mydivh;
			  var mytblid=this.mytblid;
			  var mycols=this.mycols;
			  var mydgs=this.mydgs;
			  var fn=this.fn;

			  var rowIndex="";

              if((input.length)==0){
				   return;
			   }
	
               RemoveMyDiv();
	
               $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
			   //$(document.body).append('<div id="drugsfollower" style="width:650px;height:335px;border:1px solid #E6F1FA;position:absolute"></div>') 
			   $("#"+mydivid).append('<div id='+mytblid+'></div>');

               var mydiv=$("#"+mydivid);
               /*
               var dh=mydiv.height();
			   var eh=event.clientY;
			   var bh=$(document.body).height();
	
			   if ((dh+eh)>bh)
			   {
				   h=eh-dh;
			   }else{
					 h=eh ;
			   }

			   var dw=mydiv.width();
			   var ew=event.clientX;
			   var bw=$(document.body).width();

			   if ((dw+ew)>bw)
			   {
				   w=ew-dw;
			   }else{
					 w=ew ;
			   }

			   */
			 
			  mydiv.show();
			  //mydiv.css("left",document.body.scrollLeft+w+50); 
			  //mydiv.css("top",document.body.scrollLeft+h+10);  grid��
			  //mydiv.css("top",jQuery(obj).offset().top + jQuery(obj).outerHeight());
			  
			  mydiv.css("left",tarobj.offset().left);
			  mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());


			  if (mycols=='')
			  {
				  	  mycols = [[
						  {field:'InciCode',title:'����',width:60}, 
						  {field:'InciDesc',title:'����',width:220}, 
						  {field:'Spec',title:'���',width:80},
						  {field:'ManfName',title:'����',width:80},
						  {field:'PuomDesc',title:'��ⵥλ',align:'center',width:80},
						  {field:'pSp',title:'�ۼ�(��ⵥλ)',align : 'right',width:60},  
						  {field:'PuomQty',title:'����(��ⵥλ)',align:'right',width:60},
						��{field:'BuomDesc',title:'������λ',align:'center',width:60},
						  {field:'bSp',title:'�ۼ�(������λ)',align : 'right',width:60},
						  {field:'BuomQty',title:'����(������λ)',align:'right',width:60},
						  {field:'BillUomDesc',title:'�Ƽ۵�λ',align:'center',width:60},
						  {field:'PhcdfDr',title:'PhcdfDr',align:'center',width:60}

					  ]];
			  }
	
			  if (mydgs=='')
			  {
					mydgs = {
						//url: url+'?action=QueryDrugDs&input=lhn',  //csp, ��Ϊnull
						url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
						columns: mycols,  //����Ϣ
						pagesize:10,  //һҳ��ʾ��¼��
						table: '#drugsgrid', //grid ID
						field:'InciCode', //��¼Ψһ��ʶ
						params:null,  // �����ֶ�,��Ϊnull
						tbar:null //�Ϲ�����,��Ϊnull

					}
			  }

		      var gridobj = new DataGrid(mydgs);
              gridobj.init();

              var mygrid=$("#"+mytblid);
              mygrid.datagrid('getPanel').panel('panel').focus() ;
			
			  mygrid.gridupdown(mygrid);
			  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
				
                switch (e.keyCode) {
                case 13: // enter
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   var PhcdfDr=mygrid.datagrid('getSelected').PhcdfDr ;
				   rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
				   RemoveMyDiv();
				   fn(InciDesc,PhcdfDr);
				   return ;
				   
                case 27:  //Esc
				   RemoveMyDiv();
				   fn('');
				   return;

				}
				


			  })

              
			  mygrid.datagrid('getPanel').panel('panel').blur(function() { 
 

				 if (rowIndex=="")
				 {
					 //alert(1)
					//RemoveMyDiv();
					//fn('');

				 }

				   

				   
			  });


			    //���
			  function RemoveMyDiv()
			  {
				if($("#"+mydivid).length>0)
				   {
					   $("#"+mydivid).remove(); 
					   $("#"+mytblid).remove(); 
				   }
			  }
              
			  //����Ŀ���ý�
			  function SetTargetFocus(obj)
			  {
				  obj.focus();
			  }





		}



	}


  
	var ShowWinSelectDrugs= function(input,tarobj,mydivid,mydivw,mydivh,mytblid)
   {
            
			   alert("a")
               if((input.length)==0){
				   return;
			   }
	
               RemoveMyDiv();

               $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
			   //$(document.body).append('<div id="drugsfollower" style="width:650px;height:335px;border:1px solid #E6F1FA;position:absolute"></div>') 
			   $("#"+mydivid).append('<div id='+mytblid+'></div>');

               var mydiv=$("#"+mydivid);
               /*
               var dh=mydiv.height();
			   var eh=event.clientY;
			   var bh=$(document.body).height();
	
			   if ((dh+eh)>bh)
			   {
				   h=eh-dh;
			   }else{
					 h=eh ;
			   }

			   var dw=mydiv.width();
			   var ew=event.clientX;
			   var bw=$(document.body).width();

			   if ((dw+ew)>bw)
			   {
				   w=ew-dw;
			   }else{
					 w=ew ;
			   }

			   */
			 
			  mydiv.show();
			  //mydiv.css("left",document.body.scrollLeft+w+50); 
			  //mydiv.css("top",document.body.scrollLeft+h+10);  grid��
			  //mydiv.css("top",jQuery(obj).offset().top + jQuery(obj).outerHeight());
			  
			  mydiv.css("left",tarobj.offset().left);
			  mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());
	
			  var drugsgridcols = [[
				  {field:'InciCode',title:'����',width:60}, 
				  {field:'InciDesc',title:'����',width:220}, 
				  {field:'Spec',title:'���',width:80},
				  {field:'ManfName',title:'����',width:80},
				  {field:'PuomDesc',title:'��ⵥλ',align:'center',width:80},
				  {field:'pSp',title:'�ۼ�(��ⵥλ)',align : 'right',width:60},  
				  {field:'PuomQty',title:'����(��ⵥλ)',align:'right',width:60},
				��{field:'BuomDesc',title:'������λ',align:'center',width:60},
                  {field:'bSp',title:'�ۼ�(������λ)',align : 'right',width:60},
			      {field:'BuomQty',title:'����(������λ)',align:'right',width:60},
				  {field:'BillUomDesc',title:'�Ƽ۵�λ',align:'center',width:60}

			  ]];

			  var dgs = {
					//url: url+'?action=QueryDrugDs&input=lhn',  //csp, ��Ϊnull
					url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
					columns: drugsgridcols,  //����Ϣ
					pagesize:10,  //һҳ��ʾ��¼��
					table: '#drugsgrid', //grid ID
					field:'InciCode', //��¼Ψһ��ʶ
					params:null,  // �����ֶ�,��Ϊnull
					tbar:null //�Ϲ�����,��Ϊnull

				}

		      var gridobj = new DataGrid(dgs);
              gridobj.init();

              var mygrid=$("#"+mytblid);
              mygrid.datagrid('getPanel').panel('panel').focus() ;
			  mygrid.gridupdown(mygrid);
			  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
                switch (e.keyCode) {
                case 13: // enter
				   
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   var rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
				   RemoveMyDiv();
				   fn(InciDesc);
	
				   return
                case 27:
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   RemoveMyDiv();
				   fn(InciDesc);
				 
				}
				


			  })

			  mygrid.datagrid('getPanel').panel('panel').blur(function() { 
				   
				   RemoveMyDiv();
				   fn(rowid);
				   
			  });
			    //���
			  function RemoveMyDiv()
			  {
				if($("#"+mydivid).length>0)
				   {
					   $("#"+mydivid).remove(); 
					   $("#"+mytblid).remove(); 
				   }
			  }
              
			  //����Ŀ���ý�
			  function SetTargetFocus(obj)
			  {
				  obj.focus();
			   }

        


   }

 


 
   



