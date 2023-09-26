//dhcris.MouthDesign.js
var tmpNum="";
Ext.require(['Ext.button.*', // ��ť��
		'Ext.form.*', // ����
		'Ext.MessageBox.*' // ��ʾ����
]);
//����·��
var URL_CONSTANT={
	URL:{
	    FORM_COMMIT:"dhcris.MouthDesign.Request.csp?action=COMMIT"     ///���ύ
	    }
}

//������Ƶ� �ύ
var BTContainer2 = Ext.create('Ext.container.Container',{
		anchor: '100%', //������
		layout:'column',
		height:40,
		items:[
		    {xtype : 'button',margin : '5 15 0 200',width : 100,text : '�ύ',
			handler: function(){
						this.disabled = true;//��ť������
						alert("�ύ������");

						var input=Ext.getCmp('ToothNum').getRawValue();	
						if(input==""){
							Ext.Msg.alert('��ʾ','��ѡ��λ');
							return;
						} 
						if(OEorditemID==""){
						    Ext.Msg.alert('��ʾ','ҽ��ID����Ϊ��');
							return;	
						}
						Ext.Ajax.request({ 
							method:'post',     
 							url: URL_CONSTANT.URL.FORM_COMMIT,   //�����ַ 
  							//�ύ������   
							params: {                            //����  ���·�װ�ύ����   
								input:input,  
								OEorditemID:OEorditemID 							   
							},   
							success: function(response){
								var rtnSta=response.statusText;
								Ext.Msg.alert('��ʾ','�ύ�ɹ��I');
								this.disabled = false;//��ť����			
							}
								
 						}); 					
			}
		}
		]
});

function IninTooth()
{
	Ext.getCmp('ToothPrompt').setValue("<b><font color='red'>" + ToothData + "</font></b>");
		///������λ Ӱ��Ԫ�� ToothNum
	Ext.getCmp('ToothNum').setValue(ToothData);
	
}

function remove(a,b){ 
    var c=a.split(','),d=""; 
    for(var i=0;i<c.length;i++){ 
        d+=c[i]==b?"":","+c[i]; 
    } 
    return d.length>0?d.substring(1):""; 
} 

//��λ��ʾ���ƺ���   �Q�ּ�
function switchADV(e){
		//document.getElementById(id).style.color='red';
		//parentNode ��ȡ�ĵ�����еĸ�����C 
		//parentElement ��ȡ�������еĸ�����C
		/*
		var table=e.parentNode.parentNode.parentNode
		var SPANs=table.getElementsByTagName("SPAN");
		for(var i=0;i<SPANs.length;i++){
			var span=SPANs[i];
			span.style.color='#0000FF';
		}*/
		var eSrc = window.event.srcElement;
		//alert(eSrc.innerText)
		var color=eSrc.style.color;
		var ToothNum="";
		if(color=='red'){
			eSrc.style.color='#0000FF';
			if (tmpNum!="")
			{
				tmpNum=remove(tmpNum,eSrc.innerText);
			}
			
		}else{
			eSrc.style.color='red';
			ToothNum=eSrc.innerText;
			if(tmpNum=="")
			{
				tmpNum=ToothNum;
			}else
			{
				tmpNum=tmpNum+","+ToothNum;
			} 
		}
		Ext.getCmp('ToothPrompt').setValue("<b><font color='red'>" + tmpNum + "</font></b>");
		///������λ Ӱ��Ԫ�� ToothNum
		Ext.getCmp('ToothNum').setValue(tmpNum);
	}

//��λ��ʾ���ƺ���   �Q�ּ�
function switchADV2(e){
		//document.getElementById(id).style.color='red';
		//parentNode ��ȡ�ĵ�����еĸ�����C 
		//parentElement ��ȡ�������еĸ�����C
		var table=e.parentNode.parentNode.parentNode
		var SPANs=table.getElementsByTagName("SPAN");
		for(var i=0;i<SPANs.length;i++){
			var span=SPANs[i];
			span.style.color='#0000FF';
		}		
		var eSrc = window.event.srcElement;
		//alert(eSrc.innerText)
		var color=eSrc.style.color;
		if(color=='red'){
			eSrc.style.color='#0000FF';
		}else{
			eSrc.style.color='red';
		}
		///������λ ��ʾ
		var ToothNum=eSrc.innerText;
		Ext.getCmp('ToothPrompt').setValue("<b><font color='red'>" + ToothNum + "</font></b>");
		///������λ Ӱ��Ԫ�� ToothNum
		Ext.getCmp('ToothNum').setValue(ToothNum);
	
	}

//�Q�ּ�1
var htmlstr=(
	"<table id='FToothNUM' border='1'>"+
	"<tr>"+
		"<td id='td1'>"+
			"<span id='118' class='slidlayer1' onclick='switchADV(this)'>18</span>"+
     		"<span id='117' class='slidlayer1' onclick='switchADV(this)'>17</span>"+
     		"<span id='116' class='slidlayer1' onclick='switchADV(this)'>16</span>"+
     		"<span id='115' class='slidlayer1' onclick='switchADV(this)'>15</span>"+
     		"<span id='114' class='slidlayer1' onclick='switchADV(this)'>14</span>"+
     		"<span id='113' class='slidlayer1' onclick='switchADV(this)'>13</span>"+
     		"<span id='112' class='slidlayer1' onclick='switchADV(this)'>12</span>"+
     		"<span id='111' class='slidlayer1' onclick='switchADV(this)'>11</span>"+
		"</td>"+
		"<td id='td2'>"+
			"<span id='221' class='slidlayer2' onclick='switchADV(this)'>21</span>"+
     		"<span id='222' class='slidlayer2' onclick='switchADV(this)'>22</span>"+
     		"<span id='223' class='slidlayer2' onclick='switchADV(this)'>23</span>"+
     		"<span id='224' class='slidlayer2' onclick='switchADV(this)'>24</span>"+
     		"<span id='225' class='slidlayer2' onclick='switchADV(this)'>25</span>"+
     		"<span id='226' class='slidlayer2' onclick='switchADV(this)'>26</span>"+
     		"<span id='227' class='slidlayer2' onclick='switchADV(this)'>27</span>"+
     		"<span id='228' class='slidlayer2' onclick='switchADV(this)'>28</span>"+
		"</td>"+
	"</tr>"+
	"<tr>"+
		"<td id='td3'>"+
			"<span id='348' class='slidlayer3' onclick='switchADV(this)'>48</span>"+
     		"<span id='347' class='slidlayer3' onclick='switchADV(this)'>47</span>"+
     		"<span id='346' class='slidlayer3' onclick='switchADV(this)'>46</span>"+
     		"<span id='345' class='slidlayer3' onclick='switchADV(this)'>45</span>"+
     		"<span id='344' class='slidlayer3' onclick='switchADV(this)'>44</span>"+
     		"<span id='343' class='slidlayer3' onclick='switchADV(this)'>43</span>"+
     		"<span id='342' class='slidlayer3' onclick='switchADV(this)'>42</span>"+
     		"<span id='341' class='slidlayer3' onclick='switchADV(this)'>41</span>"+
		"</td>"+
		"<td id='td4'>"+
			"<span id='431' class='slidlayer4' onclick='switchADV(this)'>31</span>"+
     		"<span id='432' class='slidlayer4' onclick='switchADV(this)'>32</span>"+
     		"<span id='433' class='slidlayer4' onclick='switchADV(this)'>33</span>"+
     		"<span id='434' class='slidlayer4' onclick='switchADV(this)'>34</span>"+
     		"<span id='435' class='slidlayer4' onclick='switchADV(this)'>35</span>"+
     		"<span id='436' class='slidlayer4' onclick='switchADV(this)'>36</span>"+
     		"<span id='437' class='slidlayer4' onclick='switchADV(this)'>37</span>"+
     		"<span id='438' class='slidlayer4' onclick='switchADV(this)'>38</span>"+
		"</td>"+
	"</tr>"+
	"</table>");
//�Q�ּ�2
var htmlstr2=(
	"<table id='FToothNUM2' border='1'>"+
	"<tr>"+
		"<td id='td1'>"+
			"<span id='18' class='slidlayer1' onclick='switchADV2(this)'>18</span>"+
     		"<span id='17' class='slidlayer1' onclick='switchADV2(this)'>17</span>"+
     		"<span id='16' class='slidlayer1' onclick='switchADV2(this)'>16</span>"+
     		"<span id='15' class='slidlayer1' onclick='switchADV2(this)'>15</span>"+
     		"<span id='14' class='slidlayer1' onclick='switchADV2(this)'>14</span>"+
     		"<span id='13' class='slidlayer1' onclick='switchADV2(this)'>13</span>"+
     		"<span id='12' class='slidlayer1' onclick='switchADV2(this)'>12</span>"+
     		"<span id='11' class='slidlayer1' onclick='switchADV2(this)'>11</span>"+
		"</td>"+
		"<td id='td2'>"+
			"<span id='21' class='slidlayer2' onclick='switchADV2(this)'>21</span>"+
     		"<span id='22' class='slidlayer2' onclick='switchADV2(this)'>22</span>"+
     		"<span id='23' class='slidlayer2' onclick='switchADV2(this)'>23</span>"+
     		"<span id='24' class='slidlayer2' onclick='switchADV2(this)'>24</span>"+
     		"<span id='25' class='slidlayer2' onclick='switchADV2(this)'>25</span>"+
     		"<span id='26' class='slidlayer2' onclick='switchADV2(this)'>26</span>"+
     		"<span id='27' class='slidlayer2' onclick='switchADV2(this)'>27</span>"+
     		"<span id='28' class='slidlayer2' onclick='switchADV2(this)'>28</span>"+
		"</td>"+
	"</tr>"+
	"<tr>"+
		"<td id='td3'>"+
			"<span id='48' class='slidlayer3' onclick='switchADV2(this)'>48</span>"+
     		"<span id='47' class='slidlayer3' onclick='switchADV2(this)'>47</span>"+
     		"<span id='46' class='slidlayer3' onclick='switchADV2(this)'>46</span>"+
     		"<span id='45' class='slidlayer3' onclick='switchADV2(this)'>45</span>"+
     		"<span id='44' class='slidlayer3' onclick='switchADV2(this)'>44</span>"+
     		"<span id='43' class='slidlayer3' onclick='switchADV2(this)'>43</span>"+
     		"<span id='42' class='slidlayer3' onclick='switchADV2(this)'>42</span>"+
     		"<span id='41' class='slidlayer3' onclick='switchADV2(this)'>41</span>"+
		"</td>"+
		"<td id='td4'>"+
			"<span id='31' class='slidlayer4' onclick='switchADV2(this)'>31</span>"+
     		"<span id='32' class='slidlayer4' onclick='switchADV2(this)'>32</span>"+
     		"<span id='33' class='slidlayer4' onclick='switchADV2(this)'>33</span>"+
     		"<span id='34' class='slidlayer4' onclick='switchADV2(this)'>34</span>"+
     		"<span id='35' class='slidlayer4' onclick='switchADV2(this)'>35</span>"+
     		"<span id='36' class='slidlayer4' onclick='switchADV2(this)'>36</span>"+
     		"<span id='37' class='slidlayer4' onclick='switchADV2(this)'>37</span>"+
     		"<span id='38' class='slidlayer4' onclick='switchADV2(this)'>38</span>"+
		"</td>"+
	"</tr>"+
	"</table>");
	
	//������Ƶ� ��������   ��λѡ��

var htmlContainer = Ext.create('Ext.container.Container', {
	anchor: '100%',
	layout:'column',
	items:[
		{//�Q�ּ�
					width:275,
					height:30,
					margin:'0 0 0 105',
					html: htmlstr2							
				},
				{
						//��ʾ��ʾ
						id:'ToothPrompt',
						fieldLabel : '��ǰ��λ',
						labelWidth : 60,
						width : 120,
						margin : '2 0 0 10',
						name : 'ToothPrompt',// ֻ���ֶ�
						xtype : 'displayfield',
						value : ""
					},
					{
						//Ӱ������
						id:'ToothNum',
						fieldLabel : '��ǰ��λ',
						labelWidth : 60,
						width : 120,
						margin : '2 0 0 10',
						name : 'ToothNum',// ֻ���ֶ�
						xtype : 'hidden',
						value : ""
					}
				
	]
});

	//������Ƶ� ����������  ������
var CBContainer3 = Ext.create('Ext.container.Container', {
		//������
		anchor: '100%',
		layout:'column',
		height:40,
		items:[
           {//�Q�ּ�
					width:275,
					height:30,
					margin:'0 0 0 55',
					html: htmlstr							
				},{
						//��ʾ��ʾ
						id:'ToothPrompt',
						fieldLabel : '��ǰ��λ',
						labelWidth : 60,
						width : 120,
						margin : '2 0 0 10',
						name : 'ToothPrompt',// ֻ���ֶ�
						xtype : 'displayfield',
						value : ""
					},{
						//Ӱ������
						id:'ToothNum',
						fieldLabel : '��ǰ��λ',
						labelWidth : 60,
						width : 120,
						margin : '2 0 0 10',
						name : 'ToothNum',// ֻ���ֶ�
						xtype : 'hidden',
						value : ""
					}
			]
});
	
//������Ƶ�������
var DBContainer = Ext.create('Ext.container.Container', {
			//��Ƶ�
		anchor: '100%',
		layout:'anchor',
		items:[{
            xtype: 'container',
            layout: 'anchor',
            items: [CBContainer3
            ]
		}]
});
	
var mainForm = Ext.create('Ext.form.Panel', {
			title : '�����',
			bodyStyle : 'padding:5 5 5 5',
			frame : true,
			// renderTo : 'form',//�ŵ�һ��1000���ص�DIV���� ���򲼾������� Ext.getBody(),
			labelAlign : "right",
			items : [{ 
				title : '��λͼ',
				xtype : 'fieldset',// ����� fieldset
				items : [{ 
					title : '��λͼ',
					xtype : 'fieldset',// ������Ƶ� fieldset
					collapsible : true,//,// �����л�
					items : [DBContainer]
				},BTContainer2
				//��������
				
				]
			}]
		});

Ext.onReady(function() {
			mainForm.render(document.body);
			IninTooth();
		})