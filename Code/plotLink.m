% Connect the link and plot the robot figure
function plotLink(app, a_i, alpha_i, d_i, tetha_i, move_link_i)
    for i = 1:length(a_i)
        L(i) = Link([tetha_i(i), d_i(i), a_i(i), alpha_i(i)]);
    end
    %figure('Name','Robot Figure');
    %hold on;
    robot = SerialLink(L, 'name', 'Robot Link');
    robot.plot(move_link_i);

end