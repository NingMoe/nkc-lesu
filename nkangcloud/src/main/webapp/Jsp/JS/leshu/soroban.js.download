				var abacus_type="Soroban";

				function display_abacus_from_intstring(numberstring) {
				

					return;
				}
				
				function initialize_abacus() {
					var columns=18;
					var abacus_size="Small";
					
					var pattern=/\/[^\/]*$/;
					mysoroban=new Abacus("mysoroban",columns,"Soroban",0,"http://leshucq.bj.bcebos.com/abacus/",abacus_size+"Soroban_image_bead.png",abacus_size+"Soroban_image_nobead.png",abacus_size+"Soroban_image_bottomborder.png",abacus_size+"Soroban_image_middlesep.png",abacus_size+"Soroban_image_top.png");
					return;
				}

				function change_abacus(newabacustype) {
					if (newabacustype != abacus_type) {
						if ((newabacustype=="SuanPan")&&(abacus_type=="Soroban")) {
							abacus_type="SuanPan";
							document.getElementById("suanpan").style.visibility="visible";
							document.getElementById("suanpan").style.zIndex=3;
							document.getElementById("helpWindowSuanpan").style.zIndex=4;
							//document.getElementById("soroban").style.visibility="hidden";
							document.getElementById("soroban").style.zIndex=1;
							document.getElementById("helpWindowSoroban").style.zIndex=2;

						}

						if ((newabacustype=="Soroban")&&(abacus_type=="SuanPan")) {
							abacus_type="Soroban";
							document.getElementById("soroban").style.visibility="visible";
							document.getElementById("soroban").style.zIndex=3;
							document.getElementById("helpWindowSoroban").style.zIndex=4;
							//document.getElementById("suanpan").style.visibility="hidden";
							document.getElementById("suanpan").style.zIndex=1;
							document.getElementById("helpWindowSuanpan").style.zIndex=2;
						}
					}
					return;
				}
				
				
				initialize_abacus();
