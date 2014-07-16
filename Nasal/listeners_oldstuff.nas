 # update engine data and start engines
  var totalFuel = 0;
  for(e=0; e < 4; e=e+1) {
    ign = getprop("/controls/engines/ign-start");
    e_start  = getprop("/controls/engines/engine["~e~"]/starter");
    e_master = getprop("/controls/engines/engine["~e~"]/master");
    e_ign    = getprop("/controls/engines/engine["~e~"]/ignition");
    e_fu_kg  = getprop("fdm/jsbsim/propulsion/engine["~e~"]/fuel-used-kg");
    totalFuel = totalFuel+e_fu_kg;
    hpsi     = getprop("/engines/engine["~e~"]/n2");
    if(hpsi == nil){
      hpsi =0.0;
    }
    if(hpsi > 30.0){
      setprop("/systems/hydraulic/pump-psi["~e~"]",60.0);
    }else{
      setprop("/systems/hydraulic/pump-psi["~e~"]",hpsi * 2);
    }
    
    if (ign == 1 and e_start == 1 and e_master == 1) {
      if (hpsi > 20 and hpsi < 22 and getprop("/controls/engines/engine["~e~"]/cutoff") == 1) {
        setprop("/controls/engines/engine["~e~"]/cutoff",0);
      }
      if (hpsi >= 26 and hpsi < 50) {
        setprop("/controls/engines/engine["~e~"]/ignition",1);
        #setprop("/controls/engines/engine["~e~"]/starter",0);
      }
    }
    if (hpsi >= 50 and ign == 1 and e_ign == 1) {
         setprop("/controls/engines/engine["~e~"]/ignition",0);
         setprop("/controls/engines/engine["~e~"]/generator",1);
         settimer(check_all_start, 10);
    }
    if (hpsi > 55) {
      if (getprop("/controls/pneumatic/engine["~e~"]/bleed") == 0) {
        setprop("/controls/pneumatic/engine["~e~"]/bleed",1);
      }
    } else {
      if (getprop("/controls/pneumatic/engine["~e~"]/bleed") == 1) {
        setprop("/controls/pneumatic/engine["~e~"]/bleed",0);
      }
    }
    ##var eng_egtF = getprop("/engines/engine["~e~"]/egt_degf");
    var eng_egtF = getprop("/engines/engine["~e~"]/egt-degf");
    eng_egtC = (5/9)*(eng_egtF-32);
    setprop("/engines/engine["~e~"]/egt_degc",eng_egtC);
    limit = getprop("/instrumentation/ecam/egt_limit_arm");
    if (eng_egtC > 920 and limit != 1) {
      settimer(check_egt_overlimit, 20);
      setprop("/instrumentation/ecam/egt_limit_arm",1);
    }
  }
  setprop("consumables/fuel/total-used-kg",totalFuel);
  
  
  
  
  
  
  # monitor eng 0 switch for ignition
setlistener("/controls/engines/engine[0]/master", func(n) {
  master = n.getValue();
  ign = getprop("/controls/engines/ign-start");
  starter_pwr = (getprop("/systems/electric/outputs/eng-starter") == 1);
  if (master == 1 and ign == 1 and starter_pwr) {
    if (getprop("/instrumentation/ecam/flight-mode") == 1) {
      setprop("/instrumentation/ecam/flight-mode",2);
    }
    setprop("/controls/engines/engine[0]/starter",1);
  }
  if (master == 0 and ign == 0) {
    setprop("/controls/engines/engine[0]/cutoff",1);
    setprop("/instrumentation/ecam/flight-mode",1);
  }
});

# monitor eng 1 switch for ignition
setlistener("/controls/engines/engine[1]/master", func(n) {
  master = n.getValue();
  ign = getprop("/controls/engines/ign-start");
  starter_pwr = (getprop("/systems/electric/outputs/eng-starter") == 1);
  if (master == 1 and ign == 1 and starter_pwr) {
    if (getprop("/instrumentation/ecam/flight-mode") == 1) {
      setprop("/instrumentation/ecam/flight-mode",2);
    }
    setprop("/controls/engines/engine[1]/starter","true");
    setprop("/controls/pneumatic/engine[1]/bleed",1);
  }
  if (master == 0 and ign == 0) {
    setprop("/controls/engines/engine[1]/cutoff",1);
  }
});

# monitor eng 2 switch for ignition
setlistener("/controls/engines/engine[2]/master", func(n) {
  master = n.getValue();
  ign = getprop("/controls/engines/ign-start");
  starter_pwr = (getprop("/systems/electric/outputs/eng-starter") == 1);
  if (master == 1 and ign == 1 and starter_pwr) {
    if (getprop("/instrumentation/ecam/flight-mode") == 1) {
      setprop("/instrumentation/ecam/flight-mode",2);
    }
    setprop("/controls/engines/engine[2]/starter","true");
  }
  if (master == 0 and ign == 0) {
    setprop("/controls/engines/engine[2]/cutoff",1);
    
  }
});

# monitor eng 3 switch for ignition
setlistener("/controls/engines/engine[3]/master", func(n) {
  master = n.getValue();
  ign = getprop("/controls/engines/ign-start");
  starter_pwr = (getprop("/systems/electric/outputs/eng-starter") == 1);
  flt_mode = getprop("/instrumentation/ecam/flight-mode");
  if (master == 1 and ign == 1 and starter_pwr) {
    if (getprop("/instrumentation/ecam/flight-mode") == 1) {
      setprop("/instrumentation/ecam/flight-mode",2);
    }
    setprop("/controls/engines/engine[3]/starter","true");
  }
  if (master == 0 and ign == 0) {
    setprop("/controls/engines/engine[3]/cutoff",1);
    if (flt_mode == 11) {
      flt_mode = 12;
      setprop("/instrumentation/ecam/flight-mode",flt_mode);
    }
  }
});


