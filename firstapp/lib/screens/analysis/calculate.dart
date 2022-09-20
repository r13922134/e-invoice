class Calculate{
  final int height,weight;
  final String gender,activity;
  late String bmirange;
  late double bmiValue; 
  late int Calorie;

  Calculate({required this.height,required this.weight,required this.gender,required this.activity});
  
  String calculateBMI(){
		bmiValue = weight/(height/100 * height/100);
		return bmiValue.toStringAsFixed(2);
	}
	
	String getInterpretation(){
    		if(bmiValue>=24) {
    		  return bmirange = "Overweight";
    		} else if(bmiValue>18.5) {
    		  return bmirange = "Normal";
    		} else {
    		  return bmirange = "Underweight";
    		}
  	}

  //Calorie calculate for Adult
	int getdailyCalorie(){
    		if(bmirange=="Underweight" && activity=="Light exercise") {
    		  Calorie = weight*35;
    		} else if(bmirange=="Underweight" && activity=="Moderate exercise") {
   		    Calorie = weight*40;
   		  } else if(bmirange=="Underweight" && activity=="Heavy exercise") {
		      Calorie = weight*45;
		    } else if(bmirange=="Normal" && activity=="Light exercise") {
		      Calorie = weight*30;
		    } else if(bmirange=="Normal" && activity=="Moderate exercise") {
    		  Calorie = weight*35;
    		} else if(bmirange=="Normal" && activity=="Heavy exercise") {
    		  Calorie = weight*40;
    		} else if(bmirange=="Overweight" && activity=="Light exercise") {
		      Calorie = weight*25;
		    } else if(bmirange=="Overweight" && activity=="Moderate exercise") {
    		  Calorie = weight*30;
    		} else {
    		  Calorie = weight*35;
    		}
        return Calorie;
    		
  	}

    //Calorie calculate for person who is 16 or 17 years old
    int getdailyCalorie_teenager(){
    		//if(genderValue=="男" && activity=="Little to no exercise") return dailyCalorie = 2150;
   		  if(gender=="男" && activity=="Light exercise") {
   		    Calorie = 2500;
   		  } else if(gender=="男" && activity=="Moderate exercise") {
		      Calorie = 2900;
		    } else if(gender=="男" && activity=="Heavy exercise") {
		      Calorie = 3350;
		    } else if(gender=="女" && activity=="Light exercise") {
    		  Calorie = 1900;
    		} else if(gender=="女" && activity=="Moderate exercise") {
          Calorie = 2350;
        } else if(gender=="女" && activity=="Heavy exercise") {
		      Calorie = 2550;
		    } else {
		      Calorie = 1500;
		    }//Fake number
        return Calorie;	
  	}

    //Calorie calculate for person who is 13 to 15 years old
    int getdailyCalorie_child(){
    		if(gender=="男" && activity=="Light exercise") {
    		  Calorie = 2400;
    		} else if(gender=="男" && activity=="Moderate exercise") {
   		    Calorie = 2800;
   		  } else if(gender=="女" && activity=="Light exercise") {
		      Calorie = 2050;
		    } else if(gender=="女" && activity=="Moderate exercise") {
    		  Calorie = 2350;
    		} else {
    		  Calorie = 1800;
    		}//Fake number
        return Calorie;
  	}
}