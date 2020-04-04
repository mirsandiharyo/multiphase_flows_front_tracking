% calculate the surface tension force on the lagrangian grid and distribute
% it to the eulerian grid
function[center] = calculate_surface_tension(domain, bubble, fluid_prop)
    % initialize the force
    [center.force_x, center.force_y] = deal(zeros(domain.nx+2, domain.ny+2));
    [tan_x, tan_y, force_x, force_y] = deal(zeros(bubble.pnt+2, bubble.pnt+2));  
    % calculate the tangent vectors
    for i=1:bubble.pnt+1
        dist = sqrt((bubble.x(i+1)-bubble.x(i))^2 + ...
            (bubble.y(i+1)-bubble.y(i))^2);
        tan_x(i) = (bubble.x(i+1)-bubble.x(i))/dist;
        tan_y(i) = (bubble.y(i+1)-bubble.y(i))/dist;
    end
    tan_x(bubble.pnt+2) = bubble_tan_x(2);
    tan_y(bubble.pnt+2) = bubble_tan_y(2);
    
    % distribute the tangent force to the eulerian grid
    for i=2:bubble.pnt+1
        % force in x-direction
        force_x = fluid_prop(1).sigma*(tan_x(i)-tan_x(i-1));
        % get the eulerian cell index
        cell_x = floor(bubble.x(i)/domain.dx)+1;
        cell_y = floor(bubble.y(i)+0.5*domain.dx)+1;
        % calculate the weighing coefficient 
        coeff_x = bubble.x(i)/domain.dx-cell_x+1;
        coeff_y = (bubble.y(i)+0.5*domain.dy)/domain.dy-cell_y+1;
        % distribute the force to the surrounding eulerian cell   
        cell.force_x(cell_x,cell_y) = cell.force_x(cell_x,cell_y) + ...
            (1.0-coeff_x)*(1.0-coeff_y)*force_x/domain.dx/domain.dy;
        cell.force_x(cell_x+1,cell_y) = cell.force_x(cell_x+1,cell_y) + ...
            coeff_x*(1.0-coeff_y)*force_x/domain.dx/domain.dy;
        cell.force_x(cell_x,cell_y+1) = cell.force_x(cell_x,cell_y+1) + ... 
            (1.0-coeff_x)*coeff_y*force_x/domain.dx/domain.dy;
        cell.force_x(cell_x+1,cell_y+1) = cell.force_x(cell_x+1,cell_y+1) + ...
            coeff_x*coeff_y*force_x/domain.dx/domain.dy;
        % force in y-direction
        force_y = fluid_prop(1).sigma*(tan_y(i)-tan_y(i-1));
        % get the eulerian cell index        
        cell_x = floor((xf(l)+0.5*dx)/dx)+1; 
        cell_y = floor(yf(l)/dy)+1;
        coeff_x = (xf(l)+0.5*dx)/dx-cell_x+1; 
        coeff_y = yf(l)/dy-cell_y+1;
        cell.force_y(cell_x,cell_y) = cell.force_y(cell_x,cell_y) + ...
            (1.0-coeff_x)*(1.0-coeff_y)*force_y/domain.dx/domain.dy;
        cell.force_y(cell_x+1,cell_y) = cell.force_y(cell_x+1,cell_y) + ...
            coeff_x*(1.0-coeff_y)*force_y/domain.dx/domain.dy;
        cell.force_y(cell_x,cell_y+1) = cell.force_y(cell_x,cell_y+1) + ...
            (1.0-coeff_x)*coeff_y*force_y/domain.dx/domain.dy;
        cell.force_y(cell_x+1,cell_y+1) = cell.force_y(cell_x+1,cell_y+1) + ...
            coeff_x*coeff_y*force_y/domain.dx/domain.dy;
    end
end