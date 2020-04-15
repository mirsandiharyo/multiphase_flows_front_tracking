% interpolate velocities located on eulerian cells to a lagrangian marker point
function[vel] = interpolate_velocity(domain, face_vel, x, y, dir)
    % get the eulerian cell index
    [index_x, index_y] = get_cell_index(x, y, domain.dx, domain.dy, dir); 
	% calculate the weighing coefficient 
    [coeff_x, coeff_y] = get_weight_coeff(x, y, domain.dx, domain.dy, ...
        index_x, index_y, dir); 
    % interpolate the surrounding velocities to the marker location
    vel = (1.0-coeff_x)*(1.0-coeff_y)*face_vel(index_x  ,index_y  )+ ...
               coeff_x *(1.0-coeff_y)*face_vel(index_x+1,index_y  )+ ...
          (1.0-coeff_x)*     coeff_y *face_vel(index_x  ,index_y+1)+ ...
               coeff_x *     coeff_y *face_vel(index_x+1,index_y+1);  
end