function discomfort = comfort_light(illuminance,illum_reference)


% Current illuminance level in lux is compared with the reference
% illuminance for visual comfort.
% If reference lux > current lux, then agent needs electric lighting [0]
% If reference lux < current lux, then agent doesn't need lighting [1] 
% If reference lux /current lux < 50%, then agent needs to shade the space
% [2]

if illum_reference <= illuminance && illuminance/illum_reference < 2,
    discomfort = 1;
elseif illum_reference > illuminance,
    discomfort = 0;
else
    discomfort =2;
    
end


end

